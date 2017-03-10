#!/usr/bin/perl
#######################################################
# Daily script to burn any generic perspective files
# It will use data from the header file
#
# Mark G. Naumowicz@verizon.com         11/28/2006
########################################################

use open ':std', IO => ':bytes'; # Shut off perl8 UTF-8 encoding thingy
use POSIX qw(strftime);
use Date::Manip;
use Date::Parse;
use File::stat;
use File::Stat;
use DBI();

# --- Definitions time ---------------------------------------------------
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdat)=localtime(time);
$mon            = sprintf("%02d", $mon+1);
$mday           = sprintf("%02d", $mday);
$year           = 1900+$year;
$hfile	        = $ARGV[0];
$daystamp       = "$mon-$mday-$year";
$watch_dir      = "/f5v1/liveuser/perspective/";
$dest_dir       = "$watch_dir$daystamp";
$timein 	= UnixDate('now','%D %r');
# -----------------------------------------------------------------------
 
$dbh = DBI->connect("dbi:Sybase:server=licdtex1", 'sa', 'glaus1', {PrintError => 0});
die "Unable for connect to server $DBI::errstr" unless $dbh;
$dbh->do("use POF7");
 
$dbh2 = DBI->connect("dbi:Sybase:server=licdtex1", 'sa', 'glaus1', {PrintError => 0});
die "Unable for connect to server $DBI::errstr" unless $dbh2;
$dbh2->do("use POF7");

$dbh3 = DBI->connect("dbi:Sybase:server=licdtex1", 'sa', 'glaus1', {PrintError => 0});
die "Unable for connect to server $DBI::errstr" unless $dbh3;
$dbh3->do("use POF7");

$dbh4 = DBI->connect("dbi:Sybase:server=licdtex1", 'sa', 'glaus1', {PrintError => 0});
die "Unable for connect to server $DBI::errstr" unless $dbh4;
$dbh4->do("use POF7");

$dbh5 = DBI->connect("dbi:Sybase:server=licdtex1", 'sa', 'glaus1', {PrintError => 0});
die "Unable for connect to server $DBI::errstr" unless $dbh5;
$dbh5->do("use ups");

$dbh6 = DBI->connect("dbi:Sybase:server=licdtex1", 'sa', 'glaus1', {PrintError => 0});
die "Unable for connect to server $DBI::errstr" unless $dbh6;
$dbh6->do("use ups");

$dbh7 = DBI->connect("dbi:Sybase:server=licdtex1", 'sa', 'glaus1', {PrintError => 0});
die "Unable for connect to server $DBI::errstr" unless $dbh7;
$dbh7->do("use ups");


if(!$ARGV[0]){ print "Error!: Missing argument. Usage $0 Header file to process\n"; exit;}

$dfile = $hfile;
$dfile =~s/\.H\./\.D\./g;

if(-e $dfile){
	print "datafile $dfile present, starting procedures...\n";

# Create custom directories for cust-ID and volume
($j1,$jd,$vol_num,$j4,$cust_id) = split(/\./, $dfile);
	
	$md0 = "$dest_dir/$jd"; 	# Job directory, there are the same cids for FTS and REG
	$md1 = "$md0/$cust_id";
	$md2 = "$md1/$vol_num";
	$md3 = "$md2/CD1"; 		# Because there will be always CD number 1

        label2:

        if(-d $md3){
        print "Directory are setup correctly...\n";
        } else {
        print "Dest dir $md3 not there, working on it...\n";

		if(-d $dest_dir){
		# do nothing, skip
		} else { 
		system("mkdir $dest_dir"); 
		system("chmod 777 $dest_dir");
			}

		if(-d $md0){
                # do nothing skip
                } else {
                system("mkdir $md0");
                system("chmod 777 $md0");
                }

		if(-d $md1){
		# do nothing skip
		} else {
		system("mkdir $md1");
		system("chmod 777 $md1");
		}

		if(-d $md2){
		# do nothing
		} else {
		system("mkdir $md2");
		system("chmod 777 $md2");
		}

		if(-d $md3){
                # do nothing
                } else {
                system("mkdir $md3");
                system("chmod 777 $md3");
                }
        	goto label2;
          }

	} else {
	print "datafile $dfile is missing, exiting...\n";
	exit;
	}

open(FH, $hfile) or die "Cannot Open file $!\n";

while($single_line=<FH>){
 
        if($single_line=~/TIME_STAMP\=/){
        $ts = "$'";
	$ts =~s/\s+$//g;
        chomp($ts);
        print "Found time_stamp - $ts\n";
        
	} elsif ($single_line=~/CUSTOMER_ID\=/){
        $cid = "$'";
	$cid =~s/\s+$//g;
        chomp($cid);
        print "Found customer_id - $cid\n";
 	
	} elsif ($single_line=~/CUSTOMER_NAME\=/){
        $c_name = "$'";
	$c_name =~s/\'//g;
	$c_name =~s/\s+$//g;
        chomp($c_name);
        print "Found customer_name - $c_name\n";
        
	} elsif ($single_line=~/ATTENTION_TO\=/){
        $att = "$'";
	$att =~s/\'//g;
	$att =~s/\s+$//g;
        chomp($att);
        print "Found attention_to - $att\n"; 
        
	} elsif ($single_line=~/ADDRESS_1\=/){
        $add1 = "$'";
	$add1 =~s/\'//g;
        $add1 =~s/\s+$//g;
        chomp($add1);
        print "Found address1 - $add1\n";
	
	} elsif ($single_line=~/ADDRESS_2\=/){
        $add2 = "$'";
	$add2 =~s/\'//g;
        $add2 =~s/\s+$//g;
        chomp($add2);
        print "Found address2 - $add2\n";
	
	} elsif ($single_line=~/ADDRESS_3\=/){
        $add3 = "$'";
	$add3 =~s/\'//g;
        $add3 =~s/\s+$//g;
        chomp($add3);
        print "Found address3 - $add3\n";
	
	} elsif ($single_line=~/CITY\=/){
        $city = "$'";
        $city =~s/\s+$//g;
        chomp($city);
        print "Found city - $city\n";
        
	} elsif ($single_line=~/STATE\=/){
        $state = "$'";
        $state =~s/\s+$//g;
        chomp($state);
        print "Found state - $state\n";
        	
	} elsif ($single_line=~/ZIPCODE\=/){
        $zip = "$'";
        $zip =~s/\s+$//g;
        chomp($zip);
        print "Found zip - $zip\n";

        } elsif ($single_line=~/ZIP4\=/){
        $z4 = "$'";
        $z4 =~s/\s+$//g;
        chomp($z4);
        print "Found zip4 - $z4\n";

        } elsif ($single_line=~/POSTAL_CODE\=/){
        $pc = "$'";
        $pc =~s/\s+$//g;
        chomp($pc);
        print "Found postal_code - $pc\n";

        } elsif ($single_line=~/COUNTRY\=/){
        $ctry = "$'";
        $ctry =~s/\s+$//g;
        chomp($ctry);
        print "Found country - $ctry\n";

        } elsif ($single_line=~/PHONE\=/){
        $ph = "$'";
        $ph =~s/\s+$//g;
        chomp($ph);
        print "Found phone - $ph\n";

        } elsif ($single_line=~/PHONE_EXT\=/){
        $phx = "$'";
        $phx =~s/\s+$//g;
        chomp($phx);
        print "Found phone_ext - $phx\n";

        } elsif ($single_line=~/PRODUCT\=/){
        $prd = "$'";
        $prd =~s/\s+$//g;
        chomp($prd);
        print "Found product - $prd\n";

        } elsif ($single_line=~/VERSION\=/){
        $v = "$'";
        $v =~s/\s+$//g;
        chomp($v);
        print "Found version - $v\n";

        } elsif ($single_line=~/DATA_DATE\=/){
        $dd = "$'";
        $dd =~s/\s+$//g;
        chomp($dd);
        print "Found date of data - $dd\n";

        } elsif ($single_line=~/NUM_COPIES\=/){
        $nc = "$'";
        $nc =~s/\s+$//g;
	$nc =~s/^0+//g;
        chomp($nc);
	if($nc==''){ $nc = 1}
        print "Found number of copies - $nc\n";

        } elsif ($single_line=~/ZIPPED_FLAG\=/){
        $zf = "$'";
        $zf =~s/\s+$//g;
        chomp($zf);
        print "Found zipped flag - $zf\n";

        } elsif ($single_line=~/JOB_SIZE\=/){
        $js = "$'";
        $js =~s/\s+$//g;
        chomp($js);
        print "Found job size - $js\n";

        } elsif ($single_line=~/ISO_LEVEL\=/){
        $il = "$'";
        $il =~s/\s+$//g;
        chomp($il);
        print "Found iso level - $il\n";

        } elsif ($single_line=~/BARCODE\=/){
        $bc = "$'";
        $bc =~s/\s+$//g;
        chomp($bc);
        print "Found barcode - $bc\n";

        } elsif ($single_line=~/BARCODE_STANDARD\=/){
        $bs = "$'";
        $bs =~s/\s+$//g;
        chomp($bs);
        print "Found barcode standard - $bs\n";

        } elsif ($single_line=~/AUXILIARY_FILE_FLAG\=/){
        $aff = "$'";
        $aff =~s/\s+$//g;
        chomp($aff);
        print "Found Aux file flag - $aff\n";

        } elsif ($single_line=~/AUX_FILE_CD_LOC_FLAG\=/){
        $aff2 = "$'";
        $aff2 =~s/\s+$//g;
        chomp($aff2);
        print "Found Aux file flag2 - $aff2\n";

        } elsif ($single_line=~/DEBUG_FLAG\=/){
        $df = "$'";
        $df =~s/\s+$//g;
        chomp($df);
        print "Found debug flag - $df\n";

        } elsif ($single_line=~/LOGGING_COMMENT_1\=/){
        $lc1 = "$'";
        $lc1 =~s/\s+$//g;
        chomp($lc1);
        print "Found logging comment1 - $lc1\n";

        } elsif ($single_line=~/LOGGING_COMMENT_2\=/){
        $lc2 = "$'";
        $lc2 =~s/\s+$//g;
        chomp($lc2);
        print "Found logging comment2 - $lc2\n";

        } elsif ($single_line=~/LOGGING_COMMENT_3\=/){
        $lc3 = "$'";
        $lc3 =~s/\s+$//g;
        chomp($lc3);
        print "Found logging comment3 - $lc3\n";

        } elsif ($single_line=~/NUM_VOLUMNS\=/){
        $nv = "$'";
        $nv =~s/\s+$//g;
	$nv =~s/^0+//g;
        chomp($nv);
        print "Found number of volumes - $nv\n";

        } elsif ($single_line=~/SHIPPER\=/){
        $ship = "$'";
        $ship =~s/\s+$//g;
        chomp($ship);
        print "Found Shipper - $ship\n";

        } elsif ($single_line=~/LABEL_TEMPLATE\=/){
        $lt = "$'";
        $lt =~s/\s+$//g;
        chomp($lt);
        print "Found label template - $lt\n";

        } elsif ($single_line=~/LOGFILENAME\=/){
        $log = "$'";
        $log =~s/\s+$//g;
        chomp($log);
        print "Found log file - $log\n";

        } elsif($single_line=~/FILE_NAME\=/){
        $f_name = "$'";
	$f_name =~s/\s+$//g;
        chomp($f_name);
	($file_name, $start, $size, $volume) = split(/\,/, $f_name);
	$start =~s/^0+//g;
	$size =~s/^0+//g;
	$volume =~s/^0+//g;
	if($start==''){ $start = 0}
	
	system("cp $hfile $df");

	$cddir = "$md2/CD$volume";	
	system("./header.pl $start $size $dfile $file_name");
		if(-d $cddir){
		print "Dir $cddir present...\n";
		} else {
		system("mkdir $cddir");
		system("chmod 777 $cddir");
		}
	system("mv $file_name $cddir");
	system("cp $df $cddir");
	print "file $file_name created and relocated to $cddir\n";

        } elsif ($single_line=~/CDR_RECORDCOUNT\=/){
        $crc = "$'";
        $crc =~s/\s+$//g;
	$crc =~s/^0+//g;
        chomp($crc);
        print "Found CDR recordcount - $crc\n";

        } elsif ($single_line=~/NM_RECORDCOUNT\=/){
        $nrc = "$'";
        $nrc =~s/\s+$//g;
	$nrc =~s/^0+//g;
        chomp($nrc);
        print "Found NM recordcount - $nrc\n";

        } elsif ($single_line=~/ENDOFHEADER\=/){
        $eh = "$'";
        $eh =~s/\s+$//g;
        chomp($eh);
        print "Found end of header - $eh\n";

                }
	}
close FH; 

&label();

for ($count=1; $count<=$nv; $count++){

#----------------- SQL CD insert starts here---------------------------
# Each  volume from one file pair needs it's own entry, hence the loop

$SQL="insert into cdrom (jobname,priority,format,numbytes,volumelabel,copies,datetime_submitted,label1,label2,label3,label4,label5,label6,label7,label8,pofname) values ('PERS',5,40,999,'PERSTEMP','$nc',getdate(),'$dd','Vol $count of $nv','$c_name','$cid','$prd','','','','$aff')";

$sth = $dbh->prepare("$SQL");
$sth->execute() || die "Failed EXECUTE:".$dbh->errstr;
$sth->finish;

$SQL2="select cdromid from cdrom where volumelabel = 'PERSTEMP' ";
$sth2 = $dbh2->prepare("$SQL2");
 if($sth2->execute) {
 while(@dat = $sth2->fetchrow) {
    $cdromid = $dat[0];
    print "cdromid - $cdromid\n";
         }
     }
$sth2->finish;

$SQL3="update cdrom set volumelabel = '$cid' where cdromid=$cdromid";
$sth3 = $dbh3->prepare("$SQL3");
$sth3->execute() || die "Failed EXECUTE:".$dbh3->errstr;
$sth3->finish;


$SQL4="insert into \[file\] (cdromid,burnfile,burn_prefix,getpath) values ($cdromid,'','\\','\\$daystamp\\$jd\\$cust_id\\$vol_num\\CD$count\\\*\.\*')";

$sth4 = $dbh4->prepare("$SQL4");
$sth4->execute() || die "Failed EXECUTE:".$dbh4->errstr;
$sth4->finish;
}

#--------------------- SQL Label insert starts here ------------------------------------------
# Check if the record is already there

sub label(){

$SQL5="select * from mlabels where cid = '$cid' and product = '$prd'";
$sth5 = $dbh5->prepare("$SQL5");
 if($sth5){
	$sth5->execute();
 while(@dat = $sth5->fetchrow) {
	$f_cid = $dat[0];

	print "cid $cid present, updating entry...\n";

$SQL6="update mlabels set 
cname		= '$c_name',
attn		= '$att',
address1	= '$add1',
address2	= '$add2',
address3	= '$add3',
city		= '$city',
state		= '$state',
zipcode		= '$zip',
zip4		= '$z4',
postal_code	= '$pc',
country		= '$ctry',
phone		= '$ph',
phone_ext	= '$phx',
print_label	= '1',
shipper		= '$ship',
product		= '$prd',
last_print	= '$timein' where id = \'$f_cid\'";

$sth6 = $dbh6->prepare("$SQL6");
$sth6->execute() || die "Failed EXECUTE:".$dbh6->errstr;
$sth6->finish;
      }
    }
$sth5->finish;

if(!$f_cid){

$SQL7="insert into mlabels(cid,cname,attn,address1,address2,address3,city,state,zipcode,zip4,postal_code,country,phone,phone_ext,print_label,last_print,shipper,product) values ('$cid','$c_name','$att','$add1','$add2','$add3','$city','$state','$zip','$z4','$pc','$ctry','$ph','$phx',1,'$timein','$ship','$prd')";

#print "$SQL7\n";

$sth7 = $dbh7->prepare("$SQL7");
$sth7->execute() || die "Failed EXECUTE:".$dbh7->errstr;
$sth7->finish;

     }
}
#--------------------------------------------------------------------------------------------

system("/bin/mv $dfile done/$dfile.orig");
system("/bin/mv $hfile done/$hfile.orig");
system("rm -f $df");				 # Remove a copy of a header file ID.CTL
 
print "done...\n";

$dbh->disconnect();
$dbh2->disconnect();
$dbh3->disconnect();
$dbh4->disconnect();
$dbh5->disconnect();
$dbh6->disconnect();
