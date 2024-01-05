"""
Filename: .change_gtk4_theme.py
"""
import os
import sys
import subprocess
import shutil
import argparse


def remove_gtk4_theme_link(system_gtk4_theme_dir):
    """
    remove gtk4 theme link
    """
    print('--------------- clean GTK4 theme directory ---------------'.center(50, '-'))
    for _item in os.scandir(system_gtk4_theme_dir):
        print(_item.path)
        if _item.is_symlink():
            os.unlink(_item.path)
        elif _item.is_dir():
            shutil.rmtree(_item.path)
        elif _item.is_file():
            os.remove(_item.path)
    print('--------------- clean end ---------------'.center(50, '-'))


def make_gtk4_theme_link(system_gtk4_theme_dir, current_theme_gtk4_dir):
    """
    make gtk4 theme link
    """
    print('--------------- make link to GTK4 theme start ---------------'.center(50, '-'))
    for _item in os.scandir(current_theme_gtk4_dir):
        tmp_result = subprocess.run(['ln', '-s', _item.path, system_gtk4_theme_dir],
                                    capture_output=True, text=True, check=False)
        if tmp_result.returncode:
            print(f"{_item.path} failed to make link to GTK4 theme: {tmp_result.stderr}")
        else:
            print(_item.path)
    print('--------------- make end ---------------'.center(50, '-'))


if __name__ == '__main__':
    USER_HOME_DIR = os.environ['HOME']
    GTK4_DIR_NAME = 'gtk-4.0'
    SYSTEM_GTK4_THEME_DIR = USER_HOME_DIR + "/.config/" + GTK4_DIR_NAME
    THEME_DIR = USER_HOME_DIR + '/.themes/'

    parser = argparse.ArgumentParser(description='help')
    parser.add_argument('-u', '--uninstall', action='store_true', required=False, help='uninstall current GTK4 theme')
    args = parser.parse_args()

    if args.uninstall:
        remove_gtk4_theme_link(SYSTEM_GTK4_THEME_DIR)
    else:
        TMP_RESULT = subprocess.run('gsettings get org.gnome.desktop.interface gtk-theme',
                                    shell=True, capture_output=True, text=True, check=False)
        if TMP_RESULT.returncode:
            print(f"get current theme failed, Error message: {TMP_RESULT.stderr}")
        else:
            _theme_name = TMP_RESULT.stdout.strip().replace("'", "")
            _current_gtk_theme_dir = THEME_DIR + _theme_name
            THEME_EXISTS = os.path.exists(_current_gtk_theme_dir)
            if not THEME_EXISTS:
                print(f"theme directory[{_current_gtk_theme_dir}] not exist")
                sys.exit(1)
            GTK4_THEME_EXISTS = False
            for _item in os.scandir(_current_gtk_theme_dir):
                if _item.is_dir() and GTK4_DIR_NAME == _item.name:
                    GTK4_THEME_EXISTS = True
                    break
            if not GTK4_THEME_EXISTS:
                print('GTK4 directory not exist')
                sys.exit(1)
            remove_gtk4_theme_link(SYSTEM_GTK4_THEME_DIR)
            _current_theme_gtk4_dir = _current_gtk_theme_dir + "/" + GTK4_DIR_NAME
            make_gtk4_theme_link(SYSTEM_GTK4_THEME_DIR, _current_theme_gtk4_dir)
