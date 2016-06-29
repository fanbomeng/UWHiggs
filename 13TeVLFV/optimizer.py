 #author Mauro Verzetti
'small interface module to deal with optimizization'

import os
import itertools

#RUN_OPTIMIZATION = ('RUN_OPTIMIZATION' in os.environ) and eval(os.environ['RUN_OPTIMIZATION'])
RUN_OPTIMIZATION = True

_0jets = {
   'tPt'  : range(30,50,10)+[45,50],
  # 'tPt'  : [50],
   'mPt'  :[25,35,55]+ range(30,60,10),
  # 'mPt'  : [50,55],
   'deltaPhi' : [2.0,3.00,2.5,2.4,2.2],
  # 'deltaPhi' : [2.1,2.5],
   'tMtToPfMet_type1' :[80,35,70]+ range(40,70,10),#was [20,50,10]+[35]
  # 'tMtToPfMet_type1' :[70,75],#was [20,50,10]+[35]
}
_0jets_default = {
   'tPt' : 30,     #was 35
   'mPt' : 25,     #was 45
   'deltaPhi': 2.0,    #was 2.7
   'tMtToPfMet_type1' :80,  #was 50
}
_0jet_region_templates = ['tPt%i', 'mPt%i', 'deltaPhi%.2f', 'tMtToPfMet_type1%i'] #'tPt%i_mPt%i_deltaPhi%.2f_tMtToPfMet_type1%i'
def _get_0jet_regions(tPt, mPt, deltaPhi, tMtToPfMet_type1):
   pass_tPt        = [i for i in _0jets['tPt'       ] if tPt        > i] 
   pass_mPt        = [i for i in _0jets['mPt'       ] if mPt        > i] 
   pass_deltaPhi       = [i for i in _0jets['deltaPhi'      ] if deltaPhi       > i] 
   pass_tMtToPfMet_type1 = [i for i in _0jets['tMtToPfMet_type1'] if tMtToPfMet_type1 < i]

   cuts = [pass_tPt, pass_mPt, pass_deltaPhi, pass_tMtToPfMet_type1]
   pass_default_tPt        = tPt        > _0jets_default['tPt'       ] 
   pass_default_mPt        = mPt        > _0jets_default['mPt'       ] 
   pass_default_deltaPhi       = deltaPhi       > _0jets_default['deltaPhi'      ] 
   pass_default_tMtToPfMet_type1 = tMtToPfMet_type1 < _0jets_default['tMtToPfMet_type1']

   defaults = [pass_default_tPt, pass_default_mPt, pass_default_deltaPhi, pass_default_tMtToPfMet_type1]
   ret = []
   for cut_idx, opts in enumerate(cuts):
       if all(j for i,j in enumerate(defaults) if i != cut_idx):
           ret.extend([_0jet_region_templates[cut_idx] % i for i in opts])
          
   return ret
_1jets = {
    'tPt'  :[30,50,55]+ range(35,55,10),
  #  'tPt'  : [50],
    'mPt'  :[25,45,50,55]+ range(30,50,10),
  #  'mPt'  : [33],
    'tMtToPfMet_type1' :[80,45,50,55,60,70]+ range(30,50,10),
 #   'tMtToPfMet_type1' : [45,50,55],
}
_1jets_default = {
    'tPt' :25,#was  40 
    'mPt' : 30,#was 35
    'tMtToPfMet_type1' :80,#was 35
}

_1jet_region_templates = ['tPt%i', 'mPt%i',  'tMtToPfMet_type1%i']#'tPt%i_mPt%i_tMtToPfMet_type1%i'
def _get_1jet_regions(tPt, mPt, tMtToPfMet_type1):
   pass_tPt        = [i for i in _1jets['tPt'       ] if tPt        > i] 
   pass_mPt        = [i for i in _1jets['mPt'       ] if mPt        > i] 
   pass_tMtToPfMet_type1 = [i for i in _1jets['tMtToPfMet_type1'] if tMtToPfMet_type1 < i]

   cuts = [pass_tPt, pass_mPt, pass_tMtToPfMet_type1]
   pass_default_tPt        = tPt        > _1jets_default['tPt'       ] 
   pass_default_mPt        = mPt        > _1jets_default['mPt'       ] 
   pass_default_tMtToPfMet_type1 = tMtToPfMet_type1 < _1jets_default['tMtToPfMet_type1']

   defaults = [pass_default_tPt, pass_default_mPt,  pass_default_tMtToPfMet_type1]
   ret = []
   for cut_idx, opts in enumerate(cuts):
       if all(j for i,j in enumerate(defaults) if i != cut_idx):
           ret.extend([_1jet_region_templates[cut_idx] % i for i in opts])
           
   return ret

    
    
_2jets = {
    'tPt'  : [30,50,55]+range(35,55,10),
    'mPt'  : [25,30,50,55]+range(35,55,10),
    'tMtToPfMet_type1' :[80,45,60,70]+ range(30,60,10),
    'vbfMass' :[100,300,400]+ range(150, 650, 100),
    'vbfDeta' : [2.0,2.2,2.7,3.0,3.5, 4.0],
    #'tPt'  : [33],
    #'mPt'  : [33],
    #'tMtToPfMet_type1' :[55,60],
    #'vbfMass' : [450,475,525],
    #'vbfDeta' : [2.2,2.7,3.3],
}
_2jets_default = {
    'tPt' : 30,#40
    'mPt' : 25,#40
    'tMtToPfMet_type1' : 80,#was 35
    'vbfMass' : 100,#was 200
    'vbfDeta' : 2.0,#was 2.5
}

_2jet_region_templates = ['tPt%i', 'mPt%i', 'tMtToPfMet_type1%i', 'vbfMass%i', 'vbfDeta%.1f' ]#'tPt%i_mPt%i_tMtToPfMet_type1%i_vbfMass%i_vbfDeta%.1f'
def _get_2jet_regions(tPt, mPt, tMtToPfMet_type1, vbfMass, vbfDeta):
    pass_tPt        = [i for i in _2jets['tPt'       ] if tPt        > i] 
    pass_mPt        = [i for i in _2jets['mPt'       ] if mPt        > i] 
    pass_tMtToPfMet_type1 = [i for i in _2jets['tMtToPfMet_type1'] if tMtToPfMet_type1 < i]
    pass_vbfMass = [i for i in _2jets['vbfMass'] if vbfMass > i]
    pass_vbfDeta = [i for i in _2jets['vbfDeta'] if vbfDeta > i]

    cuts = [pass_tPt, pass_mPt, pass_tMtToPfMet_type1, pass_vbfMass, pass_vbfDeta]
    pass_default_tPt        = tPt        > _2jets_default['tPt'       ] 
    pass_default_mPt        = mPt        > _2jets_default['mPt'       ] 
    pass_default_tMtToPfMet_type1 = tMtToPfMet_type1 < _2jets_default['tMtToPfMet_type1']
    pass_default_vbfMass = vbfMass >  _2jets_default['vbfMass'] 
    pass_default_vbfDeta = vbfDeta > _2jets_default['vbfDeta']

    defaults = [pass_default_tPt, pass_default_mPt,  pass_default_tMtToPfMet_type1, pass_default_vbfMass, pass_default_vbfDeta]
    ret = []
    for cut_idx, opts in enumerate(cuts):
        if all(j for i,j in enumerate(defaults) if i != cut_idx):
            ret.extend([_2jet_region_templates[cut_idx] % i for i in opts])
            
    return ret
  


def empty(*args):
    return []
##
compute_regions_0jet = _get_0jet_regions if RUN_OPTIMIZATION else empty
compute_regions_1jet = _get_1jet_regions if RUN_OPTIMIZATION else empty
compute_regions_2jet = _get_2jet_regions if RUN_OPTIMIZATION else empty
##
ret0 = []
defaults = [_0jets_default['tPt'], _0jets_default['mPt'], _0jets_default['deltaPhi'], _0jets_default['tMtToPfMet_type1']]
cuts0 = [_0jets['tPt'], _0jets['mPt'], _0jets['deltaPhi'], _0jets['tMtToPfMet_type1']]
cuts1 = [_1jets['tPt'], _1jets['mPt'],  _1jets['tMtToPfMet_type1']]
cuts2 = [_2jets['tPt'], _2jets['mPt'], _2jets['tMtToPfMet_type1'], _2jets['vbfMass'], _2jets['vbfDeta']]
for cut_idx, opts in enumerate(cuts0):
    if all(j for i,j in enumerate(defaults) if i != cut_idx):
        ret0.extend([_0jet_region_templates[cut_idx] % i for i in opts])
        
regions = {'0' : [], '1' : [], '2' : [], '3' : []}

if RUN_OPTIMIZATION:

    regions = {
        '0' : [_0jet_region_templates[cut_idx] % i  for cut_idx, opts in enumerate(cuts0) for i in opts],#itertools.product(_0jets['tPt'], _0jets['mPt'], _0jets['deltaPhi'], _0jets['tMtToPfMet_type1'])],
        '1' : [_1jet_region_templates[cut_idx] % i  for cut_idx, opts in enumerate(cuts1) for i in opts],#[_1jet_region_template % i for i in itertools.product(_1jets['tPt'], _1jets['mPt'], _1jets['tMtToPfMet_type1'])],
        '2' : [_2jet_region_templates[cut_idx] % i  for cut_idx, opts in enumerate(cuts2) for i in opts],#[_2jet_region_template % i for i in itertools.product(_2jets['tPt'], _2jets['mPt'], _2jets['tMtToPfMet_type1'], _2jets['vbfMass'], _2jets['vbfDeta'])],
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
