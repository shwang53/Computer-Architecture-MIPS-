#include "cachesimulator.h"

Cache::Block* CacheSimulator::find_block(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    possibly have `address` cached.
   * 2. Loop through all these blocks to see if any one of them actually has
   *    `address` cached (i.e. the block is valid and the tags match).
   * 3. If you find the block, increment `_hits` and return a pointer to the
   *    block. Otherwise, return NULL.
   */

   uint32_t temp = extract_tag(address, _cache->get_config());
   vector<Cache::Block*> vec = _cache->get_blocks_in_set(extract_index(address, _cache->get_config()));


   for (int i = 0; i < vec.size(); i ++){
      if (vec[i]->get_tag() == temp && vec[i]->is_valid()) {
        _hits ++;
        return vec[i];
      }
   }

   return nullptr;
}

Cache::Block* CacheSimulator::bring_block_into_cache(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `_cache->get_blocks_in_set` to get all the blocks that could
   *    cache `address`.
   * 2. Loop through all these blocks to find an invalid `block`. If found,
   *    skip to step 4.
   * 3. Loop through all these blocks to find the least recently used `block`.
   *    If the block is dirty, write it back to memory.
   * 4. Update the `block`'s tag. Read data into it from memory. Mark it as
   *    valid. Mark it as clean. Return a pointer to the `block`.
   */
   uint32_t temp1 = extract_index(address, _cache->get_config());
   uint32_t temp2 = extract_tag(address, _cache->get_config());

   vector<Cache::Block*> vec = _cache->get_blocks_in_set(temp1);

     for(int i=0; i<vec.size(); i++){
       if(vec[i]->is_valid()){}
       else{
         vec[i]->set_tag(temp2);
         vec[i]->read_data_from_memory(_memory);
         vec[i]->mark_as_clean();

         vec[i]->mark_as_valid();

         return vec[i];
       }
     }

     auto temp3 = vec[0];

     for (int i = 0; i < vec.size(); i++) {
       temp3 = vec[i]->get_last_used_time() < temp3->get_last_used_time() ? vec[i] : temp3;
     }

     if(temp3->is_dirty()){
        temp3->write_data_to_memory(_memory);
     }

     temp3->set_tag(extract_tag(address, _cache->get_config()));
     temp3->read_data_from_memory(_memory);
     temp3->mark_as_valid();

     temp3->mark_as_clean();


     return temp3;
}

uint32_t CacheSimulator::read_access(uint32_t address) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found, use `bring_block_into_cache` cache `address` in `block`.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `read_word_at_offset` to return the data at `address`.
   */
   auto temp = find_block(address);
   temp = (temp == nullptr) ? bring_block_into_cache(address) : temp;


   temp->set_last_used_time((++_use_clock).get_count());

   return temp->read_word_at_offset(extract_block_offset(address, _cache->get_config()));
}

void CacheSimulator::write_access(uint32_t address, uint32_t word) const {
  /**
   * TODO
   *
   * 1. Use `find_block` to find the `block` caching `address`.
   * 2. If not found
   *    a. If the policy is write allocate, use `bring_block_into_cache`.
   *    a. Otherwise, directly write the `word` to `address` in the memory
   *       using `_memory->write_word` and return.
   * 3. Update the `last_used_time` for the `block`.
   * 4. Use `write_word_at_offset` to to write `word` to `address`.
   * 5. a. If the policy is write back, mark `block` as dirty.
   *    b. Otherwise, write `word` to `address` in memory.
   */
   auto temp = find_block(address);

   if (temp == nullptr) {
       if (_policy.is_write_allocate()){
         temp = bring_block_into_cache(address);
       }
       else {
          _memory->write_word(address, word);
          return;
      }
   }

   _use_clock++;
   temp->set_last_used_time((_use_clock).get_count());

   temp->write_word_at_offset(word, extract_block_offset(address, _cache->get_config()));

   if (_policy.is_write_back()){
      temp->mark_as_dirty();
   }
   else{
      temp->write_data_to_memory(_memory);
   }
   return;
  }
