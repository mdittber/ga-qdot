function DirList = getDirStructure(relPath)
    global root
    list = dir([root relPath]);
    DirList = cell(length(list)-2,1);
    for i=3:length(list)
        DirList(i-2) = cellstr(list(i).name);
    end
end