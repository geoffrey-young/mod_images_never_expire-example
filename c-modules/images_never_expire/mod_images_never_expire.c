#define HTTPD_TEST_REQUIRE_APACHE 1

#include "httpd.h"
#include "http_core.h"
#include "http_config.h"

/* Enforce policy with module that runs at URI translation hook */
static int translate_imgexpire(request_rec *r) {

  const char *ext;

  if ((ext = strrchr(r->uri, '.')) != NULL) {

    if (strcasecmp(ext,".gif") == 0 || strcasecmp(ext,".jpg") == 0 ||
        strcasecmp(ext,".png") == 0 || strcasecmp(ext,".jpeg") == 0) {

      if (ap_table_get(r->headers_in,"If-Modified-Since") != NULL ||
          ap_table_get(r->headers_in,"If-None-Match") != NULL) {

        /* Don't bother checking filesystem, just hand back a 304 */
        return HTTP_NOT_MODIFIED;
      }
    }
  }

  return DECLINED;
}

module MODULE_VAR_EXPORT images_never_expire_module =
{
    STANDARD_MODULE_STUFF,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    translate_imgexpire,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
};
