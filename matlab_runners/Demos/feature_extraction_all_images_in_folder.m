clm_exe = '"../../Release/FeatureExtraction.exe"';
output = './output_features_imf0/';

if( ~exist(output, 'file'))
    mkdir(output)
end

in_dirs = '../../imf0/';
verbose = true;
command = clm_exe;
command = cat(2, command, ' -rigid ');
% Remove for a speedup
command = cat(2, command, ' -verbose ');

jpg_file_list = dir( [in_dirs '*.jpg']);
% idx 1 and 2 are '.' and '..', start at 3
for idx=1:numel(jpg_file_list)
    jpg_file = [in_dirs jpg_file_list(idx).name];
    [~, name, ~] = fileparts(jpg_file);
    
    outputFile_pose = [output name '_pose.txt'];
    outputFile_fp = [output name '_fp.txt'];
    outputFile_3Dfp = [output name '_fp3D.txt'];
    outputHOG_aligned = [output name '.hog'];
    output_shape_params = [output name '.params.txt'];
    output_aus = [output name '_au.txt'];
    
    jpg_command = cat(2, command, ['-f "' jpg_file '" -op "' outputFile_pose '" -of "' outputFile_fp '" -of3D "' outputFile_3Dfp '"']);
    jpg_command = cat(2, jpg_command, [' -oaus "' output_aus '" ']);
    jpg_command = cat(2, jpg_command, [' -hogalign "' outputHOG_aligned '" -oparams "' output_shape_params '"']);
    
    dos(jpg_command); 
    
    shape_params = dlmread(output_shape_params, ',', 1, 0);
    valid_frames = shape_params(:,2);
    landmark_points = dlmread(outputFile_fp, ',', 1, 0);
    landmark_points = landmark_points(:, 3:end);
    figure;
    imshow(jpg_file);
    hold on;
    plot(landmark_points(1:end/2), landmark_points(end/2+1:end), '*');
    hold off;
end
