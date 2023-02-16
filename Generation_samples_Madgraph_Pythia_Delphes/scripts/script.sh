# ------- Universidad de los Andes, Bogota - Colombia  -------
# ------- Jorge Fraga, Ronald Rodriguez, Jesus Solano, Juan Molano, Carlos Avila    -------
# Based on Andrés F. García files
start=`date +%s`
# Load the parameter file
source config.ini
# creates auxiliar directories
mkdir ${EVENTFOLD}/Cards
mkdir ${EVENTFOLD}/ParamCard

cp ${CARDSFOLD}/${PARAMCARDFILE} ${EVENTFOLD}/ParamCard/param_card.dat
cp ${CARDSFOLD}/${DELPHESCARD} ${EVENTFOLD}/Cards/delphes_card.dat
cp ${CARDSFOLD}/${PYTHIACARD}  ${EVENTFOLD}/Cards/pythia8_card.dat
## sequence for each run
for i in `seq ${INIRUN} ${ENDRUN}`; 
    do {
	cp ${CARDSFOLD}/${RUNCARDFILE} ${EVENTFOLD}/Cards/run_card.dat
	cp ${CARDSFOLD}/${MADGRAPHFILE} ${EVENTFOLD}/Cards/mgFile.mg5
	## change all the instances on the files
	sed -i "s/SEED/$i/g" ${EVENTFOLD}/Cards/run_card.dat
	sed -i "s/SEED/$i/g" ${EVENTFOLD}/Cards/mgFile.mg5
	sed -i "s/RUNEVENTSNUM/$NUMEVENTSRUN/g" ${EVENTFOLD}/Cards/run_card.dat
	sed -i "s|FOLDEREVENTS|$EVENTFOLD|g" ${EVENTFOLD}/Cards/mgFile.mg5
	sed -i "s|NUMBERCORES|$CORESNUMBER|g" ${EVENTFOLD}/Cards/mgFile.mg5
	sed -i "s|SUBFOLDERNAME|$SUBFOLD|g" ${EVENTFOLD}/Cards/mgFile.mg5
	wait
	echo executes MG
	${MADGRAPHFOLD}/bin/mg5_aMC -f  ${EVENTFOLD}/Cards/mgFile.mg5
	sleep 1s
	wait
	echo Remove unnecessary files
        rm ${EVENTFOLD}/${SUBFOLD}_$i/Events/run_01/unweighted_events.lhe.gz
        rm ${EVENTFOLD}/${SUBFOLD}_$i/Events/run_01/m_merged_xsecs.txt 
        rm ${EVENTFOLD}/${SUBFOLD}_$i/Events/run_01/unweighted_events.root 
        rm ${EVENTFOLD}/${SUBFOLD}_$i/Events/run_01/m_pythia8.cmd
        rm ${EVENTFOLD}/${SUBFOLD}_$i/Events/run_01/run_shower.sh
        rm ${EVENTFOLD}/${SUBFOLD}_$i/Events/run_01/m_pythia8.log
        rm ${EVENTFOLD}/${SUBFOLD}_$i/Events/run_01/m_djrs.dat
        rm ${EVENTFOLD}/${SUBFOLD}_$i/Events/run_01/m_pts.dat
        rm ${EVENTFOLD}/${SUBFOLD}_$i/Events/run_01/m_pythia8_events.hepmc.gz
        rm ${EVENTFOLD}/${SUBFOLD}_$i/Events/run_01/run_01_m_banner.txt
        rm ${EVENTFOLD}/${SUBFOLD}_$i/Events/run_01/m_delphes.log
        rm ${EVENTFOLD}/${SUBFOLD}_$i/madevent.tar.gz
        rm ${EVENTFOLD}/${SUBFOLD}_$i/MGMEVersion.txt 
        rm ${EVENTFOLD}/${SUBFOLD}_$i/README 
        rm ${EVENTFOLD}/${SUBFOLD}_$i/README.systematics 
        rm ${EVENTFOLD}/${SUBFOLD}_$i/TemplateVersion.txt 
        rm ${EVENTFOLD}/${SUBFOLD}_$i/myprocid 
        rm ${EVENTFOLD}/${SUBFOLD}_$i/index.html
        rm -rf ${EVENTFOLD}/${SUBFOLD}_$i/HTML
        rm -rf ${EVENTFOLD}/${SUBFOLD}_$i/lib
        rm -rf ${EVENTFOLD}/${SUBFOLD}_$i/Source
        rm -rf ${EVENTFOLD}/${SUBFOLD}_$i/SubProcesses
        rm -rf ${EVENTFOLD}/${SUBFOLD}_$i/bin
	}
    done
wait

end=`date +%s`
runtime=$((end-start))
echo $runtime
