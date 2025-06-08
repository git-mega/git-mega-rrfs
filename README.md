# git-mega-rrfs
This is a customized (some kind of simplified) version of [`git-mega`](https://github.com/git-mega/git-mega) for the Level 2 management of the RRFS2 fix files (`FIX_RRFS2`).

Only those who have been contacted will need to learn and understand how to use this version of `git-mega`

# 1. How to use `git-mega` to do real tracking of `FIX_RRFS2`?
### NOTE:
- *Generally, we can only **add** fix files into `FIX_RRFS2` (i.e. no removal)*  
- *If there is a need to remove some binary files, it should be done and coordinated in a group work meeting with a majority of the fix file managers present*
- *Before git add binary data into the `FIX_RRFS` repo, be sure to check the file size first. Sometimes, an unexpected file size may indicate unresolved issues. It is easy to add data, but not trivial to remove data (although it can certainly be done with caution in a group meeting)*
- *All `git mega` initial steps have been completed in all RDHPCS. So we only need to follow step 1.1 for the Level 2 management of the RRFS2 fix files. Step 2 is provided below just for awareness*
### 1.1 

# 2. Under the hood
### 2.1. install 
```
git clone git@github.com:git-mega/git-mega-rrfs
cd git-mega-rrfs
./build.sh
# isMegaFile will be generated under bin/
```

### 2.2 module load git-mega in .bashrc
eg:
```
vi .bashrc
#add the following line
#source /gpfs/f6/bil-fire10-oar/world-shared/gge/git-mega-rrfs/ush/load_git-mega.sh
```

### 2.3 Backup, Sync, and Uninstall
These are expected to be handled manually.  
The file change history is tracked by the `FIX_RRFS2` repo.  
Backup `$GITROOT/.mega/` to HPSS by `sbatch save2hpss.<machine>`  
Sync `$GITROOT/.mega/` between RDHPCS through either `rsync` or `globus`  
Uninstall by removing `$GITROOT/.mega.conf` and/or `$ GITROOT/.mega/`. Be sure to backup `$GITROOT/.mega/` before removing it.
