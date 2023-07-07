import shutil
import os
from pathlib import Path
import importlib
import subprocess
import sys

def check_package_installed(package_name):
    try:
        result = subprocess.run(['pip', 'show', package_name], capture_output=True, text=True)
        if result.returncode == 0:
            print(f"Package '{package_name}' is already installed.")
        else:
            raise ModuleNotFoundError
    except ModuleNotFoundError:
        subprocess.check_call(['pip', 'install', package_name])
        print(f"Package '{package_name}' has been installed.")

# Package need to be installed
package_name = 'pre-commit'

# Installing the package only if it is not available
check_package_installed(package_name)

def gitleaksEnabled():
    """Determine if the pre-commit hook for gitleaks is enabled."""
    out = subprocess.getoutput("git config --bool hooks.gitleaks")
    if out == "false":
        return False
    return True

file = './pre-commit'

if gitleaksEnabled():
    
    if os.path.isfile(file): 

       src = f'./{file}'
       dst = '../../.git/hooks/'
       shutil.move(src, dst)
       print('''          
    gitleaks pre-commit enabled

    To disable go to 'hook/pre-web-hooks/' and run the following command:

    python gl-runner.py
''') 
       
    else:
       src = f'../../.git/hooks/{file}'
       dst = '.'
       shutil.move(src, dst)
       print('''         
     gitleaks pre-commit disabled
             
     To disable go to 'hook/pre-web-hooks/' and run the following command:
             
     python gl-runner.py            
''')
             
else:
    print('gitleaks hook disabled\
     (enable with `git config hooks.gitleaks true`)')  

print("Current working directory:", os.getcwd())