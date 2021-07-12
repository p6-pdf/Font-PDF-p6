DocProj=pdf-raku.github.io
DocRepo=https://github.com/pdf-raku/$(DocProj)
DocLinker=../$(DocProj)/etc/resolve-links.raku

all : doc

doc : $(DocLinker) docs/index.md docs/PDF/Font/Loader.md docs/PDF/Font/Loader/FontObj.md \
    docs/PDF/Font/Loader.md docs/PDF/Font/Loader/FontObj/CID.md docs/PDF/Font/Loader/Dict.md \
    docs/PDF/Font/Loader/Enc.md docs/PDF/Font/Loader/Enc/Type1.md docs/PDF/Font/Loader/Enc/Identity16.md \
    docs/PDF/Font/Loader/Enc/CMap.md docs/PDF/Font/Loader/Glyph.md

docs/index.md : README.md
	cp $< $@

docs/%.md : lib/%.rakumod
	raku -I . --doc=Markdown $< \
	| TRAIL=$* raku -p -n  $(DocLinker) \
        > $@

test :
	@prove -e"raku -I ." t

loudtest :
	@prove -e"raku -I ." -v t

$(DocLinker) :
	(cd .. && git clone $(DocRepo) $(DocProj))
