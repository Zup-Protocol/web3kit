.PHONY: gen test update-goldens open-coverage gen-l10n

gen:
	@dart run build_runner build --delete-conflicting-outputs && make gen-l10n

gen-l10n:
	@fvm flutter gen-l10n

update-goldens:
	@rm -rf test/ui/goldens && fvm flutter test --update-goldens && rm -rf test/ui/failures

open-coverage:
	@open coverage/html/index.html

test:
	@fvm flutter test --coverage --test-randomize-ordering-seed=random && \
	genhtml coverage/lcov.info -o coverage/html && \
	make open-coverage
