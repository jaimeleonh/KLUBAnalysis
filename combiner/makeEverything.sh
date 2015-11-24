#!/bin/bash
# make cards with all vars/selections

export OUTSTRING="25novtest"
export BASEMUTAU="defaultBtagLLMbbMttNoIso"
export BASETAUTAU="dijetOneBLKineMttNoIso"
export VARTAUTAU="HH_mass"
export VARMUTAU="HHKin_mass"
export ALLVARS="HH_mass HHKin_mass"
export ALLSELS="defaultBtagLLMbbMttNoIso dijetOneBLKineMttNoIso "
#"defaultBtagML defaultBtagLL dijethardisoBtagCutMMbbMtt dijetOneBL dijetOneBM dijethardisoMbbMtt dijetOneBLKine dijetOneBMKine"
#dijetOneBLKineTrig
export LAMBDAS="Lambdam4 Lambda1 Lambda2dot46 Lambda20"

#baselineiso, dijethardiso, defaultBtagML, defaultBtagLL, dijethardisoBtagCutMMbbMtt, dijetisoMbbMtt, dijetOneBL, dijetOneBM, dijethardisoMbbMtt, dijetOneBLKine, dijetOneBLKineTrig

for c in MuTau TauTau
	do
		for i in $LAMBDAS 
		do	
		for j in $ALLSELS ; 
		do 

		for v in $ALLVARS
	        #do python cardMaker.py -f /home/llr/cms/cadamuro/HHKlubAnalysis/KLUBAnalysis/analysis_TauTau/evalQCD_Plots_14Oct_FullStat/outPlotter.root -l $i -o $j -v $v -c "TauTau" 
	        #do python cardMaker.py -f ../analysis_${c}/evalQCD_Plots_18Nov_FullStat/outPlotter.root -l $i -o $j -v $v -c $c
	        do python cardMaker.py -i ../config/analysis_${c}.cfg -o $j -v $v -c $c
	    done
	done
	done 
	mv cards cards_${c}_$OUTSTRING
done

#make WS 
for c in TauTau MuTau
	do
		for i in $LAMBDAS 
		do	
		for j in $ALLSELS ; 
		do 

		for v in $ALLVARS
		do 
		cd cards_${c}_$OUTSTRING/${i}${j}${v}
		pwd
		if [ -a "hh_3_L${i}_13TeV.txt" ]
			then
			combineCards.py -S "hh_3_L${i}_13TeV.txt" >> comb.txt 
		else 
			combineCards.py -S "hh_2_L${i}_13TeV.txt" >> comb.txt 
		fi
		text2workspace.py comb.txt -o comb.root ;
		combine -M Asymptotic comb.root -m 125.0 -t -1 --expectSignal=1 -n ${i} -S 0
		combine -M Asymptotic comb.root -m 125.0 -n ${i}_forLim
		cd -
	done
	done
	done 
	done

	#./makeWS.sh _mutau_$OUTSTRING 2
#./makeWS.sh _tautau_$OUTSTRING 3


#combine with syst for limits
#for i in $LAMBDAS 
#do
#	#cd cards_mutau_$OUTSTRING/lambda${i}${BASEMUTAU}${VARMUTAU}
#	#combine -M Asymptotic comb.root -m 125.0 -n Lambda${i}_forLim 
#	#cd -
#
#	cd cards_tautau_$OUTSTRING/lambda${i}${BASETAUTAU}${VARTAUTAU}
#	combine -M Asymptotic comb.root -m 125.0 -n Lambda${i}_forLim 
#	cd -
#done

##plotting: leave it for now

