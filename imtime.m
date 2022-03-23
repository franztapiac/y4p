% Function to obtain time stamp of .tif image

% Written by Franz A. Tapia Chaca
% 10th June 2019

function t = imtime(filename)

m_data = imfinfo(filename);         % metadata
t_data = m_data.ImageDescription;   % part of metadata with time data

% text to find: DeltaT="XXX" Exposure, where XXX is the number (not 3
% characters necessarily)

string1 = 'DeltaT="';   % 8 characters
string2 = '" Exposure';

l_string1 = strfind(t_data,string1);    % location of string 1 start
l_string2 = strfind(t_data,string2);    % location of string 2 start

t_string = t_data(l_string1+8:l_string2-1); % time string
t = str2double(t_string);                   % time numeric in ms

clear m_data t_data string1 string2 l_string l_string2 t_string;

end
