get:
	compliance-masonry get
generate: get
	compliance-masonry docs gitbook FedRAMP-moderate
serve: generate
	cd exports && gitbook serve
