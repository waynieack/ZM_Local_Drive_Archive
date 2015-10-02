# ZM_Local_Drive_Archive
Archive Zoneminder events to a different local Drive

1. Mount the drive where you want to move the move the archived events 

2. Put zmlocalarchive.pl in "/usr/share/perl5/ZoneMinder/:

3. Create a Zoneminder background filter with the critera you choose including "unarchived only". 
- Check the "archive all matches" box
- Check the "Execute command on all matches" box and type "/usr/share/perl5/ZoneMinder/zmlocalarchive.pl /mnt/archivehd/"
- - Where "/mnt/archivehd/" is the new locaton where the archived events will be moved
