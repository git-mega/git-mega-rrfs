# git-mega-rrfs
This is a customized (some kind of simplified) version of [`git-mega`](https://github.com/git-mega/git-mega) for the Level2 management of the RRFS fix files (`FIX_RRFS2`).

Only those who have been contacted will need to learn and understand how to use this version of `git-mega`

# 1. How to use `git-mega` to do real tracking of `FIX_RRFS2`?

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
