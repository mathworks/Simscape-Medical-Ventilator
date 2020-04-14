function deleteDerivedFiles

wildcardList = {...
    '*_ert_rtw',...
    '*_psf.mexw64',...
    '*_ssf.mexw64',...
    '*.asv',...
    '*.autosave',...
    '*.eep',...
    '*.elf',...
    '*.hex',...
    '*.slxc',...
    };

for extentionIdx = 1:length(wildcardList)
    thisWildcard = wildcardList{extentionIdx};
    listing = dir(thisWildcard);
    for listingIdx = 1:length(listing)
        thisListing = listing(listingIdx);
        if thisListing.isdir
            rmdir(thisListing.name,'s');
        else
            delete(thisListing.name);
        end
    end
end

if exist('slprj','dir')
    rmdir('slprj','s');
end

if exist('html','dir')
    rmdir('html','s');
end

end