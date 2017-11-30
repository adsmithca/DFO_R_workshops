#Git tutorial script

#1: Git setup

#First, we set up git (replace my name and email with your own)
git config --global user.name "eric-pedersen"
git config --global user.email "eric.pedersen@dfo-mpo.gc.ca"

# Only run these next two lines if you are using Windows
# They make it easier to edit git messages (which are your records
# on the changes you've made, it's good to make this easy)
git config --global core.editor notepad
git config --global format.commitMessageColumns 72


#First: make sure you're in the right folder
#For Windows users: change my name with your user name.
cd c:/Users/PedersonE/Documents

#For Mac users, replace this with the following command:
cd ~/Documents


#Make a new directory and open it:
mkdir git_tutorial
cd git_tutorial

#Starting with git: setting up a directory
git init

#All this does is create a hidden folder in the current directory.
#We can make sure it's there (the -Force option tells the prompt to
#show all files)
ls -Force
git status

#2: staging and committing files

#now let's create a new (empty) text file:
touch "file_1"

#Then edit it.
#for Windows users, you can use these commands:
notepad "file_1"

#For Mac users, this should work:
open -e "file_1"

#We'll create a second file as well, to see how working with multiple files occurs

touch "file_2"
notepad "file_2"

#or (for Macs): 
touch "file_2"
open -e "file_2"


#Let's view the repository status:
git status

#We can now add these two files to the stage:
git add "file_1" "file_2"
git status

#The files aren't commited yet; they're just staged 
#to be committed. Let's now commit them: 
git commit
git status

#We can see the record of this commit by looking at the log:
git log --stat

#or for a simpler view:
git log --stat --oneline

#now we'll change a couple other files:

notepad "file_1"

touch "data_file"
notepad "data_file" 


#or (for Macs): 
open -e "file_1"

touch "data_file"
open -e "data_file"

git status

#We can now add these two files to the stage:
git add "data_file" "file_1"
git status

git commit -m "Added data file and added code to load data"
git log --stat --oneline

#We can also ammend the most recent commit if we realized we made a mistake:
notepad "data_file"
git add "data_file"
git commit --amend

git log --stat --oneline


#3. Viewing differences between commits
#to see what has been changed between two different commits, we use the diff command:
git diff <ID for older commit> <ID for newer commit>


