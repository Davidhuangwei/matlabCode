fp = fopen('test.mid');

Header = [77, 84, 104, 100, 0, 0, 0, 6, 0, 1, 0, 6, 0, 120];

fwrite(fp, Header, 'int8');

fwrite(fp, '