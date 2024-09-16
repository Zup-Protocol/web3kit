.PHONY: gen

gen:
	@dart run build_runner build --delete-conflicting-outputs && make gen-l10n

gen-l10n:
	@flutter gen-l10n
