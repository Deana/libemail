// CIDR library for IP testing
#ifndef __CIDR_HPP
#define __CIDR_HPP

#include <string>
#include "ip.hpp"

class CIDR
{
private:
  IP::decimal_t _lower;
  IP::decimal_t _upper;

  public:
  CIDR( const std::string & cidr );
  CIDR(){ };
  bool in( const IP &) const;
  bool overlaps( const CIDR & c ) const;

  const CIDR & operator=(const CIDR & c){
    _lower = c.lower();
    _upper = c.upper();
    return *this;
  };

  bool operator()(const CIDR & c ){
    return overlaps( c );
  };

  IP::decimal_t lower() const;
  IP::decimal_t upper() const;

};

#endif
