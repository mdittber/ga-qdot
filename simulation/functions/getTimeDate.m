%% Timestamp

function timestamp = getTimeDate()
    temp = datestr(now,31);
    timestamp = [temp(1:10) '_'];
    timestamp = [timestamp temp(12:19)];
    timestamp(14) = '-';
    timestamp(17) = '-';
end