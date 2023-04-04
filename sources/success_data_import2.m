function success = success_data_import2(filename,Sheet)
%% success data import

opts = spreadsheetImportOptions("NumVariables", 13);

% Specify sheet and range
opts.Sheet = Sheet;
opts.DataRange = "B9:N18";

% Specify column names and types
opts.VariableNames = ["PID", "Date", "VarName4", "Eval", "BK", "VarName7", "VarName8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14"];
opts.VariableTypes = ["double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Import the data

motortasksuccess = readtable(filename, opts, "UseExcel", false);

success = table2array(motortasksuccess);