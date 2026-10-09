# Directories and configuration
DIR = dir
MALICIOUS_DIR = malicious_dir
WAIT_TIME = 3

#default target
all: prepare #tells Makefile that prepare is a prerequisite of all

#create malicious_dir if it doesn't exist

prepare: #target
	mkdir -p $(MALICIOUS_DIR)



#run the antivirus daemon script

daemon: prepare #daemon is the target,prepare is the prerequisite/dependency,so prepare here is run first, then daemon is run
	./antivirusd.sh $(DIR) $(MALICIOUS_DIR) $(WAIT_TIME)



#run the restore script

restore: prepare #same as daemon: prepare
	./restore.sh $(DIR) $(MALICIOUS_DIR)
	