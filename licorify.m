function licor = licorify(filename)
%% licorify.m converts .81x Licor files into a Matlab structure (licor), 
% which is organized as follows:
%
% - licor.headers: Structure containing the 31-row header block from the .81x
% file; i.e., the 'TSource' data is stored in licor.headers.TSource
%
% - licor.footers: Structure containing the 23-row footer block, organized in
% the same way as licor.headers
%
% The rest of the licor structure is the data, which is stored in two
% different ways, for your viewing convenience:
%
% FIRST METHOD:
%
% - licor.colheaders is a cell array, where each cell contains a header
% for one of the columns (e.g., 'Etime' or 'Tcham')
%
% - licor.data is a cell array, where each cell contains a data column.
% licor.colheaders and licor.data are indexed in the same way, so
% licor.colheaders{1} is 'Type' and licor.data{1} is the corresponding
% column of data
%
% SECOND METHOD:
% 
% Each column header is used as a structure name, and the corresponding
% column of data is the structure value. e.g., the 'Pressure' data column
% is stored as licor.Pressure
%
% (c) Jack Peterson (jack@tinybike.net), 4/26/2013

licor = struct;

%% Check for .81x extension, and open the Licor file
if strcmp(filename(end-3:end), '.81x')
    fid = fopen(filename);
else
    fid = fopen(strcat(filename, '.81x'));
end

%% Process the 81x file's header section
raw_headers = textscan(fid, '%s', 31, 'delimiter', '\n');
licor.headers = struct;
for i = 1:31
    % Split each header line by tab (\t)
    parts = strtrim(regexp(raw_headers{1}{i}, '\t', 'split'));
    
    % Process the name so it can be used as a structure name
    parts{1} = strrep(strrep(strrep(parts{1}(1:end-1), ' ', ''),...
        '-', '_'), '#', '');
    
    % If there's more than one value field, place the values in a cell
    % array; otherwise, store the value as a string
    num_fields = length(parts);
    if num_fields > 2
        licor.headers.(parts{1}) = parts(2:num_fields);
    else
        licor.headers.(parts{1}) = parts{2};
    end
end

%% Process the column headers
licor.colheaders = textscan(fid,...
    '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',...
    1, 'delimiter', '\t');
num_cols = length(licor.colheaders);

%% Process the data
licor.data = textscan(fid,...
    '%d %f %s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f',...
    'delimiter', '\t', 'headerlines', 1);
for i = 1:num_cols
    licor.(licor.colheaders{i}{1}) = licor.data{i};
end

%% Process the footer information below the data
raw_footers = textscan(fid, '%s', 'delimiter', '\n');
licor.footers = struct;
for i = 1:23
    % Split each header line by tab (\t)
    parts = strtrim(regexp(raw_footers{1}{i}, '\t', 'split'));
    
    % Process the name so it can be used as a structure name
    parts{1} = strrep(strrep(strrep(strrep(parts{1}(1:end-1), ' ', ''),...
        '-', '_'), '#', ''), '/', '');
    
    % Store the value as a string
    licor.footers.(parts{1}) = parts{2};
end

fclose(fid);