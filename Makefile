.PHONY: gen test

gen:
	@dart run build_runner build --delete-conflicting-outputs && make gen-l10n

gen-l10n:
	@flutter gen-l10n

test:
	@flutter test --coverage && genhtml coverage/lcov.info -o coverage/html && open coverage/html/index.html
