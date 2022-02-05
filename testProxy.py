import requests

endpoint = ''

manages =   [
  {'host': 'http://cfproxmvp01','port':'7002', 'manage': 'MgdIVRProd01' },
  {'host': 'http://cfproxmvp01','port':'7006', 'manage': 'MgdIVRProd02' },
  {'host': 'http://cfproxmvp02','port':'7002', 'manage': 'MgdIVRProd03' },
  {'host': 'http://cfproxmvp02','port':'7006', 'manage': 'MgdIVRProd04' },
  {'host': 'http://cfproxmvp03','port':'7002', 'manage': 'MgdIVRProd05' },
  {'host': 'http://cfproxmvp03','port':'7006', 'manage': 'MgdIVRProd06' },
  {'host': 'http://cfproxmvp04','port':'7002', 'manage': 'MgdIVRProd07' },
  {'host': 'http://cfproxmvp04','port':'7006', 'manage': 'MgdIVRProd08' },
  {'host': 'http://cfproxmvp05','port':'7002', 'manage': 'MgdIVRProd09' },
  {'host': 'http://cfproxmvp05','port':'7006', 'manage': 'MgdIVRProd10' },
  ]

endpoint = '/SMSSenderProxy/SMSSenderClient?&'
gsm_to_notify = '04125426045'

for managed in manages:
  host = managed['host']
  port = managed['port']
  manage = managed['manage']
  url = f'{host}:{port}{endpoint}gsm={gsm_to_notify}&txtsms=TestMessageFrom{manage}'
  print(url)