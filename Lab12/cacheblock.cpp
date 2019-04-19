#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {
  // TODO

	if (_cache_config.get_num_tag_bits() != 32) {
    return ( _tag << (32 - _cache_config.get_num_tag_bits())) + (_index << (32-_cache_config.get_num_tag_bits()-_cache_config.get_num_index_bits()));
  }else{
    return _tag;
  }
}
