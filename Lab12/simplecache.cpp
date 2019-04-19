#include "simplecache.h"

int SimpleCache::find(int index, int tag, int block_offset) {
  // read handout for implementation details
  //return 0xdeadbeef;
    auto & temp = _cache[index];
    int tempo;

    for(int i = 0; i<temp.size(); i++){
      if( temp[i].tag()==tag && temp[i].valid()== true){
        tempo = temp[i].get_byte(block_offset);
        return tempo;
      }
    }

    return 0xdeadbeef;
}

void SimpleCache::insert(int index, int tag, char data[]) {
  // read handout for implementation details
  // keep in mind what happens when you assign in in C++ (hint: Rule of Three)

  std::vector<SimpleCacheBlock> & temp = _cache[index];

  for(size_t i = 0; i<temp.size(); i++){
    if(!temp[i].valid()){
      temp[i].replace(tag,data);
      return;
    }
  }

  auto tempo = _cache[index].begin();
  tempo->replace(tag,data);
  return;

}
