import os
import sys
from subprocess import call
import argparse 

parser = argparse.ArgumentParser()
parser.add_argument('-d','--dir', dest='dir', help='folder where the root files are output')
parser.add_argument('-j','--jobDir', dest='job', help='folder where the submit-job files are')
parser.add_argument('-r','--resubmit', action='store_true', default=False, help='blank to just read the produced root files, activate to resubmit the missing ones')
parser.add_argument('-nj','--numberofjobs', dest='nj', default=100, help='number of jobs sent')
args = parser.parse_args()




if not args.dir :
  print "Need an output folder"
  sys.exit()

listOfOuts = os.listdir(args.dir) 


a = 0
for out in listOfOuts : 
  if "outPlotter_" in out : 
    a += 1
print "Jobs that ended: " + str(a)

if not args.resubmit :
  sys.exit()

if a > args.nj :
  print "Found more outputs than jobs. Maybe need to introduce the job number"
  sys.exit()

listOfSubmits = []
done = True
for a in range(0,args.nj) :
  if "outPlotter_" + str(a) + ".root" not in listOfOuts :
    print "Resubmitting job " + str(a) + " ..."
    submit = args.job + "/submit_condor_" + str(a) + ".sub"
    os.system ( 'condor_submit %s'%(submit))
    done = False

if done : print "No jobs to resubmit!"


