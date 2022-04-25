
function model=SelectModel()
Filter={'*.mat','MAT Files (*.mat)'
'*.*','All Files (*.*)'};
[FileName, FilePath]=uigetfile(Filter,'Select Model ...');
if FileName==0
model=[];
return;
end
FullFileName=[FilePath FileName];
data=load(FullFileName);
model=data.model;
end