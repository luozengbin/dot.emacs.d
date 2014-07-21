#!/usr/bin/env python2
import sys
import Xlib.display
import xdg.IconTheme as ic

winid = sys.argv[1]
dpy = Xlib.display.Display()
win = dpy.create_resource_object('window', int(sys.argv[1], 0))
NET_WM_NAME = dpy.intern_atom('_NET_WM_NAME')
UTF8_STRING = dpy.intern_atom('UTF8_STRING')

iconName = win.get_wm_class()[1].lower()
iconPath = ic.getIconPath(iconName, 16)
title = win.get_full_property(NET_WM_NAME, UTF8_STRING).value

print '{0},{1},{2}'.format(winid, iconPath, title)
