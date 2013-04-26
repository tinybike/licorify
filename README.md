licorify.m converts .81x Licor files into a Matlab structure (licor), 
which is organized as follows:

- licor.headers: Structure containing the 31-row header block from the .81x
file; i.e., the 'TSource' data is stored in licor.headers.TSource

- licor.footers: Structure containing the 23-row footer block, organized in
the same way as licor.headers

The rest of the licor structure is the data, which is stored in two
different ways, for your viewing convenience:

FIRST METHOD:

- licor.colheaders is a cell array, where each cell contains a header
for one of the columns (e.g., 'Etime' or 'Tcham')

- licor.data is a cell array, where each cell contains a data column.
licor.colheaders and licor.data are indexed in the same way, so
licor.colheaders{1} is 'Type' and licor.data{1} is the corresponding
column of data

SECOND METHOD:

Each column header is used as a structure name, and the corresponding
column of data is the structure value. e.g., the 'Pressure' data column
is stored as licor.Pressure

(c) Jack Peterson (jack@tinybike.net), 4/26/2013