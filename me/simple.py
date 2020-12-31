#!/usr/bin/env python3
import os
from pathlib import Path
import sys

__projectdir__ = Path(os.path.dirname(os.path.realpath(__file__)) + '/../')

def getinputdict():
    """
    Direct shocks.
    """
    inputdict = {}
    inputdict['equations'] = [
    '1/c = BETA * 1/c_p*(ALPHA*a_p*k_p**(ALPHA-1) + (1-DELTA))'
    ,
    'c + k_p = a*k**ALPHA + (1-DELTA)*k'
    ,
    'a = am1_p'
    ,
    'log(am1_p)=RHO*log(am1) + epsilon_a'
    ]

    inputdict['paramssdict'] = {'ALPHA': 0.3, 'BETA': 0.95, 'DELTA': 0.1, 'RHO': 0.9}

    p = inputdict['paramssdict']

    v = {}
    v['am1'] = 1
    v['a'] = 1
    v['k'] = ((p['ALPHA'] * v['a'])/(1/p['BETA'] - 1 + p['DELTA']))**(1/(1-p['ALPHA']))
    v['c'] = v['a'] * v['k'] ** p['ALPHA'] - p['DELTA'] * v['k']
    inputdict['varssdict'] = v

    inputdict['controls'] = ['c', 'a']
    inputdict['states'] = ['am1', 'k']
    inputdict['shocks'] = ['epsilon_a']
    inputdict['logvars'] = ['a', 'am1', 'k', 'c']

    return(inputdict)


def full():
    inputdict = getinputdict()
    inputdict['savefolder'] = __projectdir__ / Path('me/temp/')

    sys.path.append(str(__projectdir__ / Path('submodules/dsge-perturbation/')))
    from dsge_bkdiscrete_func import discretelineardsgefull
    inputdict = discretelineardsgefull(inputdict) 

    return(inputdict)


# Run:{{{1
if __name__ == '__main__':
    full()

