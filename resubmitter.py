import os
from subprocess import call
import argparse 

parser = argparse.ArgumentParser()
parser.add_argument('-d','--dir', dest='dir')
parser.add_argument('-j','--jobDir', dest='job')
args = parser.parse_args()


listOfOuts = os.listdir(args.dir) 
listOfSubmits = []
done = True
for a in range(0,100) :
  if "outPlotter_" + str(a) + ".root" not in listOfOuts :
    submit = args.job + "/submit_condor_" + str(a) + ".sub"
    os.system ( 'condor_submit %s'%(submit))
    done = False

if done : print "No jobs to resubmit!"


