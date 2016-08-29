.PHONY: all build clean

LUA_VERSIONS= 5.1.5 5.2.4 5.3.3
LUA_LATEST=5.3.3
LUAROCKS_VERSION=2.3.0

all:
	@echo "- Type 'make build"
	@echo

# readme_versions="$$readme_versions* \`\`, \`\`. \`\`, latest \[\(Dockerfile\)\]\[dockerfile-url\]\n" ;\
# readme_versions="$$readme_versions* \`lua_version\`, \`lua_version_2\`, \`latest\` \[\(lua_version_2/Dockerfile\)\]\[dockerfile-url\]\n" ;\

build:
	readme_versions="" ;\
	readme_links="" ;\
	for lua_version in $(LUA_VERSIONS) ; do \
	    lua_version_2="$${lua_version%.*}" ;\
	    echo "Create \`Dockerfile\` for Lua $$lua_version" ;\
	    mkdir -p ./$$lua_version_2/luarocks ;\
	    cat lua-template.Dockerfile \
	        | sed "s/\{\{LUA_VERSION\}\}/$$lua_version/g" \
	        > ./$$lua_version_2/Dockerfile ;\
	    echo "Create \`Dockerfile\` for Luarocks $$LUAROCKS_VERSION" ;\
	    cat luarocks-template.Dockerfile \
	        | sed "s/\{\{LUA_VERSION\}\}/$$lua_version/g" \
	        | sed "s/\{\{LUAROCKS_VERSION\}\}/$(LUAROCKS_VERSION)/g" \
	        > ./$$lua_version_2/luarocks/Dockerfile ;\
	    readme_links="$$readme_links\[dockerfile-$$lua_version_2-url\]: \/\/github.com\/SuperPaintman\/docker-lua\/blob\/master\/$$lua_version_2\/Dockerfile\n" ;\
	    readme_links="$$readme_links\[dockerfile-luarocks-$$lua_version_2-url\]: \/\/github.com\/SuperPaintman\/docker-lua\/blob\/master\/$$lua_version_2\/luarocks\/Dockerfile\n" ;\
	    if [[ $(LUA_LATEST) = $$lua_version ]]; then \
	        readme_versions="$$readme_versions* \`$$lua_version\`, \`$$lua_version_2\`, \`latest\` \[\($$lua_version_2\/Dockerfile\)\]\[dockerfile-$$lua_version_2-url\]\n" ;\
	        readme_versions="$$readme_versions* \`$$lua_version-luarocks\`, \`$$lua_version_2-luarocks\`, \`luarocks\` \[\($$lua_version_2\/Dockerfile\)\]\[dockerfile-luarocks-$$lua_version_2-url\]\n" ;\
	    else \
	        readme_versions="$$readme_versions* \`$$lua_version\`, \`$$lua_version_2\` \[\($$lua_version_2\/Dockerfile\)\]\[dockerfile-$$lua_version_2-url\]\n" ;\
	        readme_versions="$$readme_versions* \`$$lua_version-luarocks\`, \`$$lua_version_2-luarocks\` \[\($$lua_version_2\/Dockerfile\)\]\[dockerfile-luarocks-$$lua_version_2-url\]\n" ;\
	    fi \
	done ;\
	echo "Create \`README.md\`" ;\
	cat README.template.md \
	    | perl -pe "s/\{\{DOCKERFILES\}\}/$$readme_versions/g" \
	    | perl -pe "s/\{\{DOCKERFILES_LINKS\}\}/$$readme_links/g" \
	    > ./README.md ;\
	echo "Done" ;

clean:
	find . -regex '^./[0-9]+\.[0-9]+\(\.[0-9]\)?+$$' -type d | xargs rm -frd ;\
	rm -f ./README.md

