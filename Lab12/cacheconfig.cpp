#include <cmath>
#include "cacheconfig.h"
#include "utils.h"


uint32_t CacheConfig::calculateLog(uint32_t n){
  return log_2(n);
}

CacheConfig::CacheConfig(uint32_t size, uint32_t block_size, uint32_t associativity)
: _size(size), _block_size(block_size), _associativity(associativity) {
  /**
   * TODO
   * Compute and set `_num_block_offset_bits`, `_num_index_bits`, `_num_tag_bits`.
  */

    uint32_t temp = size / block_size;
    temp /= associativity;

   _num_block_offset_bits = calculateLog(block_size);
   _num_index_bits = calculateLog(temp);
   _num_tag_bits = 32 - (_num_block_offset_bits) - (_num_index_bits);
}
