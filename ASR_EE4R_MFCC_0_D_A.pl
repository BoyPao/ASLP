#!c:/Program Files/Perl5.6.1/bin/perl

#####################################################################################################
# 
# This script extract features from Aurora2 'Train clean' data and performs training and testing.
# Usage:  perl ASR_EE4R.pl 
# Author: Munevver Kokuer
# Date: Nov. 2008
#####################################################################################################


# Global Variables

$REC_DIR    	= "U:\\system";
$BINDIR     	= "$REC_DIR\\HTK3.2bin"; 

$HMM_DIR    	= "$REC_DIR\\hmmsTrained";

$LIST_train	= "$REC_DIR/list/Task6_train_MFCC_list.scp"; 
$LIST_train_HCopy  = "$REC_DIR/list/Task6_train_Hcopy_list.scp"; 

$LIST_test	= "$REC_DIR/list/Task3_test_FMCC_list.scp"; 
$LIST_test_HCopy= "$REC_DIR/list/Task3_test_Hcopy_list.scp";

$CONFIG_HCopy   = "$REC_DIR/config/config_HCopy_MFCC_0_D_A";
$CONFIG_train   = "$REC_DIR/config/config_train_MFCC_0_D_A";
$CONFIG_test   	= "$REC_DIR/config/config_test_MFCC_0_D_A";

$WORD_LISTSP	= "$REC_DIR/lib/plist_withsp";
$WORD_LIST  	= "$REC_DIR/lib/plist_withoutsp";
$LABELSP    	= "$REC_DIR/label/task6_phoneme_withsp.mlf";
$LABELS    	= "$REC_DIR/label/task6_phoneme_withoutsp.mlf"; 
$LABELSTEST    	= "$REC_DIR/label/task4_test_word.mlf"; 

$ED_CMDFILE1	= "$REC_DIR/lib/tieSILandSP_EE4R.hed";
$ED_CMDFILE2	= "$REC_DIR/lib/mix2_st8_EE4R.hed";
$ED_CMDFILE3	= "$REC_DIR/lib/mix3_st8_EE4R.hed";
$ED_CMDFILE4	= "$REC_DIR/lib/mix4_st8_EE4R.hed";
$ED_CMDFILE5	= "$REC_DIR/lib/mix5_st8_EE4R.hed";
$ED_CMDFILE6	= "$REC_DIR/lib/mix6_st8_EE4R.hed";
$ED_CMDFILE7	= "$REC_DIR/lib/mix7_st8_EE4R.hed";
$ED_CMDFILE8	= "$REC_DIR/lib/mix8_st8_EE4R.hed";
$ED_CMDFILE9	= "$REC_DIR/lib/mix9_st8_EE4R.hed";
$ED_CMDFILE10	= "$REC_DIR/lib/mix10_st8_EE4R.hed";
$ED_CMDFILE11	= "$REC_DIR/lib/mix11_st8_EE4R.hed";
$ED_CMDFILE12	= "$REC_DIR/lib/mix12_st8_EE4R.hed";
$ED_CMDFILE13	= "$REC_DIR/lib/mix13_st8_EE4R.hed";
$ED_CMDFILE14	= "$REC_DIR/lib/mix14_st8_EE4R.hed";
$ED_CMDFILE15	= "$REC_DIR/lib/mix15_st8_EE4R.hed";
$ED_CMDFILE16	= "$REC_DIR/lib/mix16_st8_EE4R.hed";

$Proto      	= "$REC_DIR/lib/proto_s1d39_st8m1_EE4R_MFCC_0_D_A";
$mod_file 	= "$HMM_DIR/hmm68/models";
$mac_file 	= "$HMM_DIR/hmm68/macros"; 

$flags      	= "-p 0 -s 0.0";
$NET        	= "$REC_DIR\\lib\\wnet";
$DICT       	= "$REC_DIR\\lib\\wdict"; 

$NUM_COEF   	= 39; 
$PAR_TYPE   	= "MFCC_0_D_A";

$RESULT 	= "$REC_DIR\\result\\task6_Result_MFCC_0_D_A.res";


open(STDOUT, ">$REC_DIR\\result\\task6_LogASR_MFCC_E_D_A.log") or die "Can't write to STDOUT $!";


#-------------------------------------------------------------------------
# Feature Extraction for mfcc_e_d_a
# HCopy: Calls HCopy to convert AURORA TESTA data files to HTK parameterised 'mfcc_e_d_a'
#-------------------------------------------------------------------------

print "Coding data\n";

system("$BINDIR/HCopy -C $CONFIG_HCopy -S $LIST_train_HCopy");
system("$BINDIR/HCopy -C $CONFIG_HCopy -S $LIST_test_HCopy");

print "Coding complete\n";

#-------------------------------------------------------------------------
# Training 
#-------------------------------------------------------------------------

print "Training...\n";

foreach $i (0..68) {
    mkdir("$HMM_DIR\\hmm$i");
}

system "$BINDIR\\HCompV -C $CONFIG_train -o hmmdef -f 0.01 -m -S $LIST_train -M $HMM_DIR/hmm0 $Proto";

print("Seed Hmm succesfully produced\n"); 

system "$BINDIR/macro $NUM_COEF $PAR_TYPE $HMM_DIR/hmm0/vFloors $HMM_DIR/hmm0/macros";
### creates the file "models" containing the HMM definition of all 11 digits and the silence model
#system "$BINDIR/models_1mixsil $HMM_DIR/hmm0/hmmdef $HMM_DIR/hmm0/models";

###Training 
foreach $i (1..3) {
	print "Iteration Number $i\n";
	$j=$i-1;
	system "$BINDIR/HERest -D -C $CONFIG_train -I $LABELS -t 250.0 150.0 1000.0 -S $LIST_train -H $HMM_DIR/hmm$j/macros -H $HMM_DIR/hmm$j/models -M $HMM_DIR/hmm$i $WORD_LIST";
}
print "3 Iterations completed\n";

#system("copy $HMM_DIR\\hmm3 $HMM_DIR\\hmm4");
#system "$BINDIR/spmodel_gen $HMM_DIR/hmm3/models $HMM_DIR/hmm4/models";
system "$BINDIR/HHEd -T 2 -H $HMM_DIR/hmm4/macros -H $HMM_DIR/hmm4/models -M $HMM_DIR/hmm5 $ED_CMDFILE1 $WORD_LISTSP";
print "SP model fixed\n";

foreach $i (6..8) {
	$j=$i-1;
	system "$BINDIR/HERest -C $CONFIG_train -I $LABELSP -S $LIST_train -H $HMM_DIR/hmm$j/macros -H $HMM_DIR/hmm$j/models -M $HMM_DIR/hmm$i $WORD_LISTSP";
}
print "6 Iterations completed\n";

  system "$BINDIR/HHEd -T 2 -H $HMM_DIR/hmm8/macros -H $HMM_DIR/hmm8/models -M $HMM_DIR/hmm9 $ED_CMDFILE2 $WORD_LISTSP";
  print "2 Gaussians per mixture created\n";
  foreach $i (10..12) {
	  $j=$i-1;
	  system "$BINDIR/HERest -C $CONFIG_train -I $LABELSP -S $LIST_train -H $HMM_DIR/hmm$j/macros -H $HMM_DIR/hmm$j/models -M $HMM_DIR/hmm$i $WORD_LISTSP";
  }
 print "9 Iterations completed\n";
 
   system "$BINDIR/HHEd -T 2 -H $HMM_DIR/hmm12/macros -H $HMM_DIR/hmm12/models -M $HMM_DIR/hmm13 $ED_CMDFILE3 $WORD_LISTSP";
  print "2 Gaussians per mixture created\n";
  foreach $i (14..16) {
	  $j=$i-1;
	  system "$BINDIR/HERest -C $CONFIG_train -I $LABELSP -S $LIST_train -H $HMM_DIR/hmm$j/macros -H $HMM_DIR/hmm$j/models -M $HMM_DIR/hmm$i $WORD_LISTSP";
  }
 print "12 Iterations completed\n";
 
    system "$BINDIR/HHEd -T 2 -H $HMM_DIR/hmm16/macros -H $HMM_DIR/hmm16/models -M $HMM_DIR/hmm17 $ED_CMDFILE4 $WORD_LISTSP";
  print "2 Gaussians per mixture created\n";
  foreach $i (18..20) {
	  $j=$i-1;
	  system "$BINDIR/HERest -C $CONFIG_train -I $LABELSP -S $LIST_train -H $HMM_DIR/hmm$j/macros -H $HMM_DIR/hmm$j/models -M $HMM_DIR/hmm$i $WORD_LISTSP";
  }
 print "15 Iterations completed\n";

     system "$BINDIR/HHEd -T 2 -H $HMM_DIR/hmm20/macros -H $HMM_DIR/hmm20/models -M $HMM_DIR/hmm21 $ED_CMDFILE5 $WORD_LISTSP";
  print "2 Gaussians per mixture created\n";
  foreach $i (22..24) {
	  $j=$i-1;
	  system "$BINDIR/HERest -C $CONFIG_train -I $LABELSP -S $LIST_train -H $HMM_DIR/hmm$j/macros -H $HMM_DIR/hmm$j/models -M $HMM_DIR/hmm$i $WORD_LISTSP";
  }
 print "18 Iterations completed\n";

      system "$BINDIR/HHEd -T 2 -H $HMM_DIR/hmm24/macros -H $HMM_DIR/hmm24/models -M $HMM_DIR/hmm25 $ED_CMDFILE6 $WORD_LISTSP";
  print "2 Gaussians per mixture created\n";
  foreach $i (26..28) {
	  $j=$i-1;
	  system "$BINDIR/HERest -C $CONFIG_train -I $LABELSP -S $LIST_train -H $HMM_DIR/hmm$j/macros -H $HMM_DIR/hmm$j/models -M $HMM_DIR/hmm$i $WORD_LISTSP";
  }
 print "21 Iterations completed\n";
 
 
      system "$BINDIR/HHEd -T 2 -H $HMM_DIR/hmm28/macros -H $HMM_DIR/hmm28/models -M $HMM_DIR/hmm29 $ED_CMDFILE7 $WORD_LISTSP";
  print "2 Gaussians per mixture created\n";
  foreach $i (30..32) {
	  $j=$i-1;
	  system "$BINDIR/HERest -C $CONFIG_train -I $LABELSP -S $LIST_train -H $HMM_DIR/hmm$j/macros -H $HMM_DIR/hmm$j/models -M $HMM_DIR/hmm$i $WORD_LISTSP";
  }
 print "24 Iterations completed\n";
 
      system "$BINDIR/HHEd -T 2 -H $HMM_DIR/hmm32/macros -H $HMM_DIR/hmm32/models -M $HMM_DIR/hmm33 $ED_CMDFILE8 $WORD_LISTSP";
  print "2 Gaussians per mixture created\n";
  foreach $i (34..36) {
	  $j=$i-1;
	  system "$BINDIR/HERest -C $CONFIG_train -I $LABELSP -S $LIST_train -H $HMM_DIR/hmm$j/macros -H $HMM_DIR/hmm$j/models -M $HMM_DIR/hmm$i $WORD_LISTSP";
  }
 print "27 Iterations completed\n";
  
      system "$BINDIR/HHEd -T 2 -H $HMM_DIR/hmm36/macros -H $HMM_DIR/hmm36/models -M $HMM_DIR/hmm37 $ED_CMDFILE9 $WORD_LISTSP";
  print "2 Gaussians per mixture created\n";
  foreach $i (38..40) {
	  $j=$i-1;
	  system "$BINDIR/HERest -C $CONFIG_train -I $LABELSP -S $LIST_train -H $HMM_DIR/hmm$j/macros -H $HMM_DIR/hmm$j/models -M $HMM_DIR/hmm$i $WORD_LISTSP";
  }
 print "30 Iterations completed\n";
 
       system "$BINDIR/HHEd -T 2 -H $HMM_DIR/hmm40/macros -H $HMM_DIR/hmm40/models -M $HMM_DIR/hmm41 $ED_CMDFILE10 $WORD_LISTSP";
  print "2 Gaussians per mixture created\n";
  foreach $i (42..44) {
	  $j=$i-1;
	  system "$BINDIR/HERest -C $CONFIG_train -I $LABELSP -S $LIST_train -H $HMM_DIR/hmm$j/macros -H $HMM_DIR/hmm$j/models -M $HMM_DIR/hmm$i $WORD_LISTSP";
  }
 print "33 Iterations completed\n";
 

       system "$BINDIR/HHEd -T 2 -H $HMM_DIR/hmm44/macros -H $HMM_DIR/hmm44/models -M $HMM_DIR/hmm45 $ED_CMDFILE11 $WORD_LISTSP";
  print "2 Gaussians per mixture created\n";
  foreach $i (46..48) {
	  $j=$i-1;
	  system "$BINDIR/HERest -C $CONFIG_train -I $LABELSP -S $LIST_train -H $HMM_DIR/hmm$j/macros -H $HMM_DIR/hmm$j/models -M $HMM_DIR/hmm$i $WORD_LISTSP";
  }
 print "36 Iterations completed\n";
 
        system "$BINDIR/HHEd -T 2 -H $HMM_DIR/hmm48/macros -H $HMM_DIR/hmm48/models -M $HMM_DIR/hmm49 $ED_CMDFILE12 $WORD_LISTSP";
  print "2 Gaussians per mixture created\n";
  foreach $i (50..52) {
	  $j=$i-1;
	  system "$BINDIR/HERest -C $CONFIG_train -I $LABELSP -S $LIST_train -H $HMM_DIR/hmm$j/macros -H $HMM_DIR/hmm$j/models -M $HMM_DIR/hmm$i $WORD_LISTSP";
  }
 print "39 Iterations completed\n";
 
         system "$BINDIR/HHEd -T 2 -H $HMM_DIR/hmm52/macros -H $HMM_DIR/hmm52/models -M $HMM_DIR/hmm53 $ED_CMDFILE13 $WORD_LISTSP";
  print "2 Gaussians per mixture created\n";
  foreach $i (54..56) {
	  $j=$i-1;
	  system "$BINDIR/HERest -C $CONFIG_train -I $LABELSP -S $LIST_train -H $HMM_DIR/hmm$j/macros -H $HMM_DIR/hmm$j/models -M $HMM_DIR/hmm$i $WORD_LISTSP";
  }
 print "42 Iterations completed\n";
 
          system "$BINDIR/HHEd -T 2 -H $HMM_DIR/hmm56/macros -H $HMM_DIR/hmm56/models -M $HMM_DIR/hmm57 $ED_CMDFILE14 $WORD_LISTSP";
  print "2 Gaussians per mixture created\n";
  foreach $i (58..60) {
	  $j=$i-1;
	  system "$BINDIR/HERest -C $CONFIG_train -I $LABELSP -S $LIST_train -H $HMM_DIR/hmm$j/macros -H $HMM_DIR/hmm$j/models -M $HMM_DIR/hmm$i $WORD_LISTSP";
  }
 print "45 Iterations completed\n";
 
           system "$BINDIR/HHEd -T 2 -H $HMM_DIR/hmm60/macros -H $HMM_DIR/hmm60/models -M $HMM_DIR/hmm61 $ED_CMDFILE15 $WORD_LISTSP";
  print "2 Gaussians per mixture created\n";
  foreach $i (62..64) {
	  $j=$i-1;
	  system "$BINDIR/HERest -C $CONFIG_train -I $LABELSP -S $LIST_train -H $HMM_DIR/hmm$j/macros -H $HMM_DIR/hmm$j/models -M $HMM_DIR/hmm$i $WORD_LISTSP";
  }
 print "48 Iterations completed\n";
 
            system "$BINDIR/HHEd -T 2 -H $HMM_DIR/hmm64/macros -H $HMM_DIR/hmm64/models -M $HMM_DIR/hmm65 $ED_CMDFILE16 $WORD_LISTSP";
  print "2 Gaussians per mixture created\n";
  foreach $i (66..68) {
	  $j=$i-1;
	  system "$BINDIR/HERest -C $CONFIG_train -I $LABELSP -S $LIST_train -H $HMM_DIR/hmm$j/macros -H $HMM_DIR/hmm$j/models -M $HMM_DIR/hmm$i $WORD_LISTSP";
  }
 print "51 Iterations completed\n";
 
print "Training complete\n";

#-------------------------------------------------------------------------
# Testing 
#-------------------------------------------------------------------------

print "Testing...\n";

system "$BINDIR/HVite -H $mac_file -H $mod_file -S $LIST_test -C $CONFIG_test -w $NET -i $REC_DIR/result/result.mlf $flags $DICT $WORD_LISTSP";

system ("$BINDIR/HResults -e \"???\" sil -e \"???\" sp -I $LABELSTEST $WORD_LISTSP $REC_DIR/result/result.mlf >> $RESULT "); 

print "Testing complete\n";
print("\n------------------------------------------------------------------\n");


#--------------------------------------------------------------------------#
#                   End of Script: ASR_EE4R.pl 	                           #
#--------------------------------------------------------------------------#