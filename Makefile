.PHONY: index clean

index:
	rm -rf simple
	mkdir -p simple
	echo '<!DOCTYPE html><html><body>' > simple/index.html
	for f in *.whl *.tar.gz; do \
		[ -e "$$f" ] || continue; \
		base="$${f%.tar.gz}"; \
		base="$${base%.whl}"; \
		pkg="$$(echo "$$base" | sed -E 's/-[0-9].*//' | tr 'A-Z' 'a-z' | sed -E 's/[-_.]+/-/g')"; \
		mkdir -p "simple/$$pkg"; \
		if [ ! -f "simple/$$pkg/index.html" ]; then \
			echo '<!DOCTYPE html><html><body>' > "simple/$$pkg/index.html"; \
			echo "<a href=\"$$pkg/\">$$pkg</a>" >> simple/index.html; \
		fi; \
		hash="$$(sha256sum "$$f" | cut -d' ' -f1)"; \
		echo "<a href=\"../../$$f#sha256=$$hash\">$$f</a>" >> "simple/$$pkg/index.html"; \
	done
	for d in simple/*/; do echo '</body></html>' >> "$$d/index.html"; done
	echo '</body></html>' >> simple/index.html

clean:
	rm -rf simple