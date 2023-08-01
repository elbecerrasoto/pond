#!/usr/bin/env zsh

ENV_DEFAULT=dev

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/ebecerra/mambaforge/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/ebecerra/mambaforge/etc/profile.d/conda.sh" ]; then
        . "/home/ebecerra/mambaforge/etc/profile.d/conda.sh"
    else
        export PATH="/home/ebecerra/mambaforge/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/home/ebecerra/mambaforge/etc/profile.d/mamba.sh" ]; then
    . "/home/ebecerra/mambaforge/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<
mamba activate "$ENV_DEFAULT"

mamba install -y -c conda-forge r-tidyverse
mamba install -y -c conda-forge ncbi-datasets-cli
mamba install -y -c conda-forge r-seqinr
mamba install -y -c conda-forge openjdk
