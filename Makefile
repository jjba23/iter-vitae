# Iter Vitae 

# Copyright © Josep Bigorra <jjbigorra@gmail.com>

# iter-vitae is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# iter-vitae is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with iter-vitae. If not, see <https://www.gnu.org/licenses/>.

# dev version runs from source code
#
# resources need to be manually taken
define dev-persona
	guix shell -m manifest.scm -- \
		guile -L ./src -c '((@(iter-vitae main) main))' \
		--locale $(2) --persona-file $(1) --output-dir ./dist --resources-dir ./resources
endef

# packaged version runs via Guix, in the Guix store
#
# resources will automatically be handled for you
#
# if you installed iter-vitae via Guix you can simply do, e.g.:
#     iter-vitae --locale en --persona-file ./my-cv.scm --output-dir ./dist
define persona
	guix shell -f guix.scm -- \
		iter-vitae --locale $(2) --persona-file $(1) --output-dir ./dist
endef

serve:
	darkhttpd ./dist --port 50023

persona-joe-nl:
	$(call persona,"$(realpath ./populus/joe.scm)","nl")
persona-joe-en:
	$(call persona,"$(realpath ./populus/joe.scm)","en")
dev-persona-joe-nl:
	$(call dev-persona,"$(realpath ./populus/joe.scm)","nl")
dev-persona-joe-en:
	$(call dev-persona,"$(realpath ./populus/joe.scm)","en")

dev:
	watchexec -i "dist/**" -r -e scm,css,js -- "make dev-persona-joe-nl && make serve"


deploy:
	make persona-joe-en
	rm -rfv /srv/http/jointhefreeworld.org/joe-cv
	cp -rfv dist /srv/http/jointhefreeworld.org/joe-cv
fmt:
	find . -maxdepth 6 -name "*.scm" -type f -exec guix style -f {} \;

# Development REPL
repl:
	guix shell -m manifest.scm -- \
		guile \
		-L ./src \
		-c '((@ (ares server) run-nrepl-server))'
