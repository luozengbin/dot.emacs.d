#include <gtk/gtk.h>
#include <gdk/gdk.h>
#include <gio/gio.h>
#include <stdio.h>

int main (int argc, char **argv)
{
    g_thread_init (NULL);
    g_type_init ();

    if (argc < 2)
        return -1;

    GError *error;
    GFile *file = g_file_new_for_path (argv[1]);
    GFileInfo *file_info = g_file_query_info (file,
                                              "standard::*",
                                              0,
                                              NULL,
                                              &error);

    const char *content_type = g_file_info_get_content_type (file_info);
    char *desc = g_content_type_get_description (content_type);
    GAppInfo *app_info = g_app_info_get_default_for_type (
        content_type,
        FALSE);

    /* you'd have to use g_loadable_icon_load to get the actual icon */
    GIcon *icon = g_file_info_get_icon (file_info);
    //gchar **icon_names = g_themed_icon_get_names((GThemedIcon *)icon);
    char  **icon_names;
    g_object_get (icon, "names", &icon_names, NULL);
    GtkIconTheme *icon_theme = gtk_icon_theme_get_for_screen(gdk_screen_get_default()); //gtk_icon_theme_get_default();
    //GtkIconInfo  *icon_info = gtk_icon_theme_lookup_icon(icon_theme, "gnome-mime-text-x-csrc", 16, 0);
    GtkIconInfo  *icon_info = gtk_icon_theme_choose_icon (icon_theme, (const char **)icon_names, 32, 0);
    const gchar *icon_file = gtk_icon_info_get_filename(icon_info);
    printf ("File: %s\nDescription: %s\nDefault Application: %s\nIcon: %s\n",
            argv[1],
            desc,
            g_app_info_get_executable (app_info),
            icon_file
            //g_icon_to_string(icon)
        );

    return 0;
}

