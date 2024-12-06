# Iter Vitae 

# Copyright (C) 2024 Josep Jesus Bigorra Algaba

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

define persona
	rm -rfv dist
	mkdir dist
	GUILE_AUTOCOMPILE=0 guile main.scm --locale $(2) --persona $(1)
	cp -rfv resources/css dist/
	cp -rfv resources/js dist/
	cp -rfv resources/ttf dist/
	@printf "\n\nall tasks completed\n\n"
endef

persona-joe-nl:
	$(call persona,"joe","nl")
persona-joe-en:
	$(call persona,"joe","en")
persona-manon-nl:
	$(call persona,"manon","nl")
persona-manon-en:
	$(call persona,"manon","en")
