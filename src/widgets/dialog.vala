/* dialog.vala
 *
 * Copyright 2023 Pedro Miguel
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

namespace ValaXml {
    [GtkTemplate(ui = "/valaxlm/pedromigueldev/github/ui/dialog.ui")]
    public class Dialog : Adw.MessageDialog {

        [GtkChild]  public unowned Gtk.Entry url_entry;
        [GtkChild]  public unowned Gtk.Label error_message;

        public string url;

        protected delegate void Search_page(string url);
        public void open_dialog(Search_page search_page_function){
            this.response.connect ((response) => {

                if (response == "cancel") return;
                print(this.url);
                search_page_function(this.url);
            });

            this.show ();
        }



        public Dialog (Window parent) {
            transient_for = parent;

            url_entry.notify["text"].connect ((e, p) => {

                if (  url_entry.text.has_prefix("https://") ||  url_entry.text.has_prefix("http://")){
                    url =  url_entry.text;
                } else {
                     url = "https://" +  url_entry.text;
                }

                if ( !ValaXml.Utils.verify_url(url) ) {
                    this.error_message.set_visible (true);
                    this.set_response_enabled ("search", false);
                    return;
                }
                this.set_response_enabled ("search", true);
                this.error_message.set_visible (false);

            });

        }
    }
}
