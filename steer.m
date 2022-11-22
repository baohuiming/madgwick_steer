clear
close all

port = 'COM9';
baudrate = 115200;

s = serialport(port,baudrate);


p1 = polarscatter(0,1,2000,'b.');
set(gca,'ThetaZeroLocation','left','ThetaDir','clockwise','RTick',[],'RLim',[0 1.2]);
hold on;p2 = polarplot([0 1],'b','LineWidth',5);

for i=0:0.05:2*pi
    set(p1,'ThetaData',i);
    set(p2,'ThetaData',[0 i]);
    set(p2,'RData', [0 1]);
    drawnow
end

angle = 0;

i = 0;
while 1
    i = i + 1;
    if mod(i,200) > 0 % 定期更新
        continue
    else
        i = 0;
    end
    
    % 从串口中获取正确数据 --start--
    flush(s);
    s_str = read(s,20,'char');
    % AG=<***>，起到校核的作用
    s_res = regexp(s_str, '(?<=AG=<).*?(?=>)', 'match'); 
    if isempty(s_res)
        continue
    else
        ago = s_res(1);
    end
    if ~contains(ago,'.')
        continue
    else
        ago = str2double(ago);
    end
    if isnan(ago) % 异常处理
        continue
    else
        angle = ago;
    end
    % --end--
    
    angle = angle / 180 * pi;
    set(p1,'ThetaData',angle);
    set(p2,'ThetaData',[0 angle]);
    set(p2,'RData', [0 1]);
    drawnow
end