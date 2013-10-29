# -*- coding: utf-8 -*-
"""Declaration of API shortcuts."""
from django_downloadview.io import StringIteratorIO  # NoQA
from django_downloadview.files import (StorageFile,  # NoQA
                                       VirtualFile,
                                       HTTPFile,
                                       File)
from django_downloadview.response import (DownloadResponse,  # NoQA
                                          ProxiedDownloadResponse)
from django_downloadview.middlewares import (BaseDownloadMiddleware,  # NoQA
                                             DownloadDispatcherMiddleware)
from django_downloadview.views import (PathDownloadView,  # NoQA
                                       ObjectDownloadView,
                                       StorageDownloadView,
                                       HTTPDownloadView,
                                       VirtualDownloadView,
                                       BaseDownloadView,
                                       DownloadMixin)
from django_downloadview.sendfile import sendfile  # NoQA
from django_downloadview.test import (assert_download_response,  # NoQA
                                      temporary_media_root)
