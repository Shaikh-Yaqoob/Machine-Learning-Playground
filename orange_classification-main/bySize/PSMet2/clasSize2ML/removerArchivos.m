function [ output_args ] = removerArchivos( archivoBorrar)

    comando = { 'rm','-rf',archivoBorrar};
    command=strjoin(comando);
    [status,cmdout] = system(command);
    
end

