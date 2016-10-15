 #author Mauro Verzetti
'small interface module to deal with optimizization'

import os
import itertools

#RUN_OPTIMIZATION = ('RUN_OPTIMIZATION' in os.environ) and eval(os.environ['RUN_OPTIMIZATION'])
RUN_OPTIMIZATION = True

_0jets = {
  # 'tPt'  : range(30,50,10)+[45,50],
   'tPt'  : [30],
  # 'tPt'  : [50],
  # 'mPt'  :[25,30,35]+ range(40,60,10)+[55],
   'mPt'  :[25],
  # 'mPt'  : [50,55],
  # 'deltaPhi' : [2.95,2.9,2.85,2.8,2.7],
   #'DeltaPhi' : [2.80,2.70,2.6,2.5,2.4],
   'DeltaPhi' : [0.2],
  # 'DeltaPhi' : [0.2],
#   'deltaPhi' : [2.80,2.70],
 #  'mmetdeltaPhi' : [0.0],
   #'tmetdeltaPhi' : [2.6,2.7,2.8,2.9,3.0,3.1],
   'tmetdeltaPhi' : [3.0],
   #'deltaPhi' : [3.00,2.8,2.7,2.6,2.5,2.4,2.2,2.0],
  # 'deltaPhi' : [2.1,2.5],
  # 'tMtToPfMet_type1' :[80,35,70]+ range(40,70,10),#was [20,50,10]+[35]
   'tMtToPfMet_type1' :[95],#was [20,50,10]+[35]
  # 'tMtToPfMet_type1' :[70,75],#was [20,50,10]+[35]
}
_0jets_default = {
   'tPt' : 30,     #was 35
   'mPt' : 25,     #was 45
   'DeltaPhi': 0,    #was 2.7
   'tmetdeltaPhi' :3.0,  #was 50
   'tMtToPfMet_type1' :105,  #was 50
  # 'mmetdeltaPhi' :0.0,  #was 50
}
_0jet_region_templates = ['tPt%i', 'mPt%i', 'DeltaPhi%.2f','tmetdeltaPhi%.2f', 'tMtToPfMet_type1%i'] #'tPt%i_mPt%i_deltaPhi%.2f_tMtToPfMet_type1%i'
def _get_0jet_regions(tPt, mPt, DeltaPhi,tmetdeltaPhi, tMtToPfMet_type1):
   pass_tPt        = [i for i in _0jets['tPt'       ] if tPt        > i] 
   pass_mPt        = [i for i in _0jets['mPt'       ] if mPt        > i] 
   pass_DeltaPhi       = [i for i in _0jets['DeltaPhi'      ] if DeltaPhi       > i] 
#   pass_mmetdeltaPhi       = [i for i in _0jets['mmetdeltaPhi'      ] if mmetdeltaPhi       > i] 
   pass_tmetdeltaPhi       = [i for i in _0jets['tmetdeltaPhi'      ] if tmetdeltaPhi       < i] 
   pass_tMtToPfMet_type1 = [i for i in _0jets['tMtToPfMet_type1'] if tMtToPfMet_type1 < i]

   cuts = [pass_tPt, pass_mPt, pass_DeltaPhi,pass_tmetdeltaPhi,pass_tMtToPfMet_type1]
   pass_default_tPt        = tPt        > _0jets_default['tPt'       ] 
   pass_default_mPt        = mPt        > _0jets_default['mPt'       ] 
   pass_default_DeltaPhi       = DeltaPhi       > _0jets_default['DeltaPhi'] 
 #  pass_default_mmetdeltaPhi       = mmetdeltaPhi       > _0jets_default['mmetdeltaPhi'] 
   pass_default_tmetdeltaPhi       = tmetdeltaPhi       < _0jets_default['tmetdeltaPhi'] 
   pass_default_tMtToPfMet_type1 = tMtToPfMet_type1 < _0jets_default['tMtToPfMet_type1']

   defaults = [pass_default_tPt, pass_default_mPt, pass_default_DeltaPhi,pass_default_tmetdeltaPhi,pass_default_tMtToPfMet_type1]
   ret = []
   for cut_idx, opts in enumerate(cuts):
       if all(j for i,j in enumerate(defaults) if i != cut_idx):
           ret.extend([_0jet_region_templates[cut_idx] % i for i in opts])
          
   return ret
_1jets = {
   # 'tPt'  :[30,50,55]+ range(35,55,10),
   # 'tPt'  :[30]+ range(35,55,10)+[50,55],
    'tPt'  :[50],
  #  'tPt'  : [50],
    #'mPt'  :[25,45,50,55]+ range(30,50,10),
   # 'mPt'  :[25,30,40,45,50,55],
    'mPt'  :[50],
    'DeltaPhi' : [3.0], 
    'tmetdeltaPhi' : [3.2],
  #  'mPt'  : [33],
  #  'tMtToPfMet_type1' :[80,45,50,55,60,70]+ range(30,50,10),
#    'tMtToPfMet_type1' :[80,70,60,55,50,45,40,30],
    'tMtToPfMet_type1' :[105],
 #   'tMtToPfMet_type1' : [45,50,55],
}
_1jets_default = {
    'tPt' :30,#was  40 
    'mPt' : 25,#was 35
    'DeltaPhi': 0.0,  
    'tmetdeltaPhi' :3.0, 
    'tMtToPfMet_type1' :105,#was 35
}

_1jet_region_templates = ['tPt%i', 'mPt%i','DeltaPhi%.2f','tmetdeltaPhi%.2f', 'tMtToPfMet_type1%i']#'tPt%i_mPt%i_tMtToPfMet_type1%i'
def _get_1jet_regions(tPt, mPt,DeltaPhi,tmetdeltaPhi, tMtToPfMet_type1):
   pass_tPt        = [i for i in _1jets['tPt'       ] if tPt        > i] 
   pass_mPt        = [i for i in _1jets['mPt'       ] if mPt        > i] 
   pass_DeltaPhi       = [i for i in _1jets['DeltaPhi'] if DeltaPhi       > i]
   pass_tmetdeltaPhi       = [i for i in _1jets['tmetdeltaPhi'      ] if tmetdeltaPhi       < i]
   pass_tMtToPfMet_type1 = [i for i in _1jets['tMtToPfMet_type1'] if tMtToPfMet_type1 < i]

   cuts = [pass_tPt, pass_mPt, pass_DeltaPhi,pass_tmetdeltaPhi,pass_tMtToPfMet_type1]
   pass_default_tPt        = tPt        > _1jets_default['tPt'       ] 
   pass_default_mPt        = mPt        > _1jets_default['mPt'       ] 
   pass_default_DeltaPhi       = DeltaPhi       > _1jets_default['DeltaPhi']
   pass_default_tmetdeltaPhi       = tmetdeltaPhi       < _1jets_default['tmetdeltaPhi']
   pass_default_tMtToPfMet_type1 = tMtToPfMet_type1 < _1jets_default['tMtToPfMet_type1']

   defaults = [pass_default_tPt, pass_default_mPt,pass_default_DeltaPhi,pass_default_tmetdeltaPhi,pass_default_tMtToPfMet_type1]
   ret = []
   for cut_idx, opts in enumerate(cuts):
       if all(j for i,j in enumerate(defaults) if i != cut_idx):
           ret.extend([_1jet_region_templates[cut_idx] % i for i in opts])
           
   return ret

    
    
_2jetsloose = {
    #'tPt'  : [30,50,55]+range(35,55,10),
   # 'tPt'  : [30,35,45,50,55],
    'tPt'  : [30],
   # 'mPt'  : [25,30,50,55]+range(35,55,10),
   # 'mPt'  : [25,30,35,45,50,55],
    'mPt'  : [25],
    #'tMtToPfMet_type1' :[80,45,60,70]+ range(30,60,10),
    #'tMtToPfMet_type1' :[80,70,60,50,45,40,30],
    'tMtToPfMet_type1' :[80,90,100,111,115],
    #'vbfMass' :[100,300,400]+ range(150, 650, 100),
    'vbfMass' :[10,50,100,150,200,250,300,400,450],
    #'vbfDeta' : [2.0,2.2,2.7,3.0,3.5, 4.0],
    #'vbfDeta' : [1.0,1.2,1.5,1.8,2.0,2.2,2.5,2.7,3.0,3.3,3.5],
    'vbfDeta' : [3.0,3.5,4.0,4.5],
    #'tPt'  : [33],
    #'mPt'  : [33],
    #'tMtToPfMet_type1' :[55,60],
    #'vbfMass' : [450,475,525],
    #'vbfDeta' : [2.2,2.7,3.3],
}
_2jetsloose_default = {
    'tPt' : 30,#40
    'mPt' : 25,#40
    'tMtToPfMet_type1' : 105,#was 35
    'vbfMass' : 650.0,#was 200
    'vbfDeta' : 3.5,#was 2.5
}

_2jetloose_region_templates = ['tPt%i', 'mPt%i', 'tMtToPfMet_type1%i', 'vbfMass%i', 'vbfDeta%.1f' ]#'tPt%i_mPt%i_tMtToPfMet_type1%i_vbfMass%i_vbfDeta%.1f'
def _get_2jetloose_regions(tPt, mPt, tMtToPfMet_type1, vbfMass, vbfDeta):
    pass_tPt        = [i for i in _2jetsloose['tPt'       ] if tPt        > i] 
    pass_mPt        = [i for i in _2jetsloose['mPt'       ] if mPt        > i] 
    pass_tMtToPfMet_type1 = [i for i in _2jetsloose['tMtToPfMet_type1'] if tMtToPfMet_type1 < i]
    pass_vbfMass = [i for i in _2jetsloose['vbfMass'] if (vbfMass > i and vbfMass<650)]
    pass_vbfDeta = [i for i in _2jetsloose['vbfDeta'] if vbfDeta < i]

    cuts = [pass_tPt, pass_mPt, pass_tMtToPfMet_type1, pass_vbfMass, pass_vbfDeta]
    pass_default_tPt        = tPt        > _2jetsloose_default['tPt'       ] 
    pass_default_mPt        = mPt        > _2jetsloose_default['mPt'       ] 
    pass_default_tMtToPfMet_type1 = tMtToPfMet_type1 < _2jetsloose_default['tMtToPfMet_type1']
    pass_default_vbfMass = (vbfMass <  _2jetsloose_default['vbfMass']  and vbfMass >0)
    pass_default_vbfDeta = vbfDeta < _2jetsloose_default['vbfDeta']

    defaults = [pass_default_tPt, pass_default_mPt,  pass_default_tMtToPfMet_type1, pass_default_vbfMass, pass_default_vbfDeta]
    ret = []
    for cut_idx, opts in enumerate(cuts):
        if all(j for i,j in enumerate(defaults) if i != cut_idx):
            ret.extend([_2jetloose_region_templates[cut_idx] % i for i in opts])
            
    return ret
  

_2jetstight = {
    #'tPt'  : [30,50,55]+range(35,55,10),
   # 'tPt'  : [30,35,45,50,55],
    'tPt'  : [30],
   # 'mPt'  : [25,30,50,55]+range(35,55,10),
   # 'mPt'  : [25,30,35,45,50,55],
    'mPt'  : [25],
    #'tMtToPfMet_type1' :[80,45,60,70]+ range(30,60,10),
    #'tMtToPfMet_type1' :[80,70,60,50,45,40,30],
    'tMtToPfMet_type1' :[115],
    #'vbfMass' :[100,300,400]+ range(150, 650, 100),
    'vbfMass' :[900],
    #'vbfDeta' : [2.0,2.2,2.7,3.0,3.5, 4.0],
    #'vbfDeta' : [1.0,1.2,1.5,1.8,2.0,2.2,2.5,2.7,3.0,3.3,3.5],
    'vbfDeta' : [4.5],
    #'tPt'  : [33],
    #'mPt'  : [33],
    #'tMtToPfMet_type1' :[55,60],
    #'vbfMass' : [450,475,525],
    #'vbfDeta' : [2.2,2.7,3.3],
}
_2jetstight_default = {
    'tPt' : 30,#40
    'mPt' : 25,#40
    'tMtToPfMet_type1' : 85,#was 35
    'vbfMass' : 650.0,#was 200
    'vbfDeta' : 3.5,#was 2.5
}

_2jettight_region_templates = ['tPt%i', 'mPt%i', 'tMtToPfMet_type1%i', 'vbfMass%i', 'vbfDeta%.1f' ]#'tPt%i_mPt%i_tMtToPfMet_type1%i_vbfMass%i_vbfDeta%.1f'
def _get_2jettight_regions(tPt, mPt, tMtToPfMet_type1, vbfMass, vbfDeta):
    pass_tPt        = [i for i in _2jetstight['tPt'       ] if tPt        > i] 
    pass_mPt        = [i for i in _2jetstight['mPt'       ] if mPt        > i] 
    pass_tMtToPfMet_type1 = [i for i in _2jetstight['tMtToPfMet_type1'] if tMtToPfMet_type1 < i]
    pass_vbfMass = [i for i in _2jetstight['vbfMass'] if vbfMass > i]
    pass_vbfDeta = [i for i in _2jetstight['vbfDeta'] if vbfDeta > i]

    cuts = [pass_tPt, pass_mPt, pass_tMtToPfMet_type1, pass_vbfMass, pass_vbfDeta]
    pass_default_tPt        = tPt        > _2jetstight_default['tPt'       ] 
    pass_default_mPt        = mPt        > _2jetstight_default['mPt'       ] 
    pass_default_tMtToPfMet_type1 = tMtToPfMet_type1 < _2jetstight_default['tMtToPfMet_type1']
    pass_default_vbfMass = vbfMass >  _2jetstight_default['vbfMass'] 
    pass_default_vbfDeta = vbfDeta > _2jetstight_default['vbfDeta']

    defaults = [pass_default_tPt, pass_default_mPt,  pass_default_tMtToPfMet_type1, pass_default_vbfMass, pass_default_vbfDeta]
    ret = []
    for cut_idx, opts in enumerate(cuts):
        if all(j for i,j in enumerate(defaults) if i != cut_idx):
            ret.extend([_2jettight_region_templates[cut_idx] % i for i in opts])
            
    return ret

def empty(*args):
    return []
##
compute_regions_0jet = _get_0jet_regions if RUN_OPTIMIZATION else empty
compute_regions_1jet = _get_1jet_regions if RUN_OPTIMIZATION else empty
compute_regions_2jetloose = _get_2jetloose_regions if RUN_OPTIMIZATION else empty
compute_regions_2jettight = _get_2jettight_regions if RUN_OPTIMIZATION else empty
##
ret0 = []
defaults = [_0jets_default['tPt'], _0jets_default['mPt'], _0jets_default['DeltaPhi'], _0jets_default['tMtToPfMet_type1']]
cuts0 = [_0jets['tPt'], _0jets['mPt'], _0jets['DeltaPhi'], _0jets['tmetdeltaPhi'], _0jets['tMtToPfMet_type1']]
cuts1 = [_1jets['tPt'], _1jets['mPt'],  _1jets['DeltaPhi'], _1jets['tmetdeltaPhi'], _1jets['tMtToPfMet_type1']]
cuts2loose = [_2jetsloose['tPt'], _2jetsloose['mPt'], _2jetsloose['tMtToPfMet_type1'], _2jetsloose['vbfMass'], _2jetsloose['vbfDeta']]
cuts2tight = [_2jetstight['tPt'], _2jetstight['mPt'], _2jetstight['tMtToPfMet_type1'], _2jetstight['vbfMass'], _2jetstight['vbfDeta']]
for cut_idx, opts in enumerate(cuts0):
    if all(j for i,j in enumerate(defaults) if i != cut_idx):
        ret0.extend([_0jet_region_templates[cut_idx] % i for i in opts])
        
regions = {'0' : [], '1' : [], '2loose' : [], '2tight' : []}

if RUN_OPTIMIZATION:

    regions = {
        '0' : [_0jet_region_templates[cut_idx] % i  for cut_idx, opts in enumerate(cuts0) for i in opts],#itertools.product(_0jets['tPt'], _0jets['mPt'], _0jets['deltaPhi'], _0jets['tMtToPfMet_type1'])],
        '1' : [_1jet_region_templates[cut_idx] % i  for cut_idx, opts in enumerate(cuts1) for i in opts],#[_1jet_region_template % i for i in itertools.product(_1jets['tPt'], _1jets['mPt'], _1jets['tMtToPfMet_type1'])],
        '2loose' : [_2jetloose_region_templates[cut_idx] % i  for cut_idx, opts in enumerate(cuts2loose) for i in opts],#[_2jet_region_template % i for i in itertools.product(_2jets['tPt'], _2jets['mPt'], _2jets['tMtToPfMet_type1'], _2jets['vbfMass'], _2jets['vbfDeta'])],
        '2tight' : [_2jettight_region_templates[cut_idx] % i  for cut_idx, opts in enumerate(cuts2tight) for i in opts],#[_2jet_region_template % i for i in itertools.product(_2jets['tPt'], _2jets['mPt'], _2jets['tMtToPfMet_type1'], _2jets['vbfMass'], _2jets['vbfDeta'])],
        #'0':[_0jet_region_template % i for i in itertools.product(_0jets['tPt'], [_0jets_default['mPt']], [_0jets_default['deltaPhi']], [_0jets_default['tMtToPfMet_type1']])] + [_0jet_region_template % i for i in itertools.product([_0jets_default['tPt']] , _0jets['mPt'], [_0jets_default['deltaPhi']], [_0jets_default['tMtToPfMet_type1']])],
        #'1':[_1jet_region_template % i for i in itertools.product(_1jets['tPt'], [_1jets_default['mPt']],[_1jets_default['tMtToPfMet_type1']])],
        #'2':[_2jet_region_template % i for i in itertools.product(_2jets['tPt'], [_2jets_default['mPt']],[_2jets_default['tMtToPfMet_type1']], [_2jets_default['vbfMass']], [_2jets_default['vbfDeta']])],
        '3' : []}
    
    print regions['0']
    
if __name__ == "__main__":
    from pdb import set_trace
    set_trace()
    #print '\n'.join(grid_search.keys())
else:
    print "Running optimization: %s" % RUN_OPTIMIZATION
