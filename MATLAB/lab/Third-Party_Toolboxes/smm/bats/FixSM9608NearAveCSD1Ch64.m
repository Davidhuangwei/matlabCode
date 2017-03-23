function FixSM9608NearAveCSD1Ch64(fileBaseMat)
if 0
    for j=1:size(fileBaseMat,1)
        cd(fileBaseMat(j,:));
        fprintf(['!cp ' fileBaseMat(j,:) '_NearAveCSD1.csd ' fileBaseMat(j,:) '_NearAveCSD1.csd.old\n']);
        eval(['!cp ' fileBaseMat(j,:) '_NearAveCSD1.csd ' fileBaseMat(j,:) '_NearAveCSD1.csd.old']);
        cd ..
    end
    return
else
    for j=1:size(fileBaseMat,1)
        cd(fileBaseMat(j,:));
        csd = bload([fileBaseMat(j,:) '_NearAveCSD1.csd.old'],[84 inf]);
        eval(['!rm ' fileBaseMat(j,:) '_NearAveCSD1.csd']);
        fpid = fopen([fileBaseMat(j,:) '_NearAveCSD1.csd'],'w');
        if fpid
            csd(64,:) = csd(63,:);
            fwrite(fpid,csd,'int16');
            if fclose(fpid)
                fprintf(['ERROR closing: ' fileBaseMat(j,:)])
                return
            end
        else
            fprintf(['ERROR opening: ' fileBaseMat(j,:)])
            return
        end
        cd ..
    end
end
