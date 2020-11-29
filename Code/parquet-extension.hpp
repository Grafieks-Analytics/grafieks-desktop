#pragma once

#include "duckdb.hpp"

namespace duckdb {

class ParquetExtension : public Extension {
public:
	void Load(DuckDB &db) override;
};

} // namespace duckdb
