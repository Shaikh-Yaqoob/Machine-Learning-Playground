function [ output_args ] = removeFiles(fileToErase)

    command = { 'rm','-rf',fileToErase};
    command=strjoin(command);
    [status,cmdout] = system(command);
    
end

