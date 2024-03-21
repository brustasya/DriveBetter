package com.matttax.drivebetter.profile.data

import android.content.Context
import android.graphics.Bitmap
import android.net.Uri
import android.provider.MediaStore
import dagger.hilt.android.qualifiers.ApplicationContext
import java.io.File
import java.io.FileOutputStream
import javax.inject.Inject
import javax.inject.Singleton

@Singleton
class IconRepository @Inject constructor(
    @ApplicationContext private val context: Context
) {

    fun saveToInternalStorage(uri: Uri, name: String, oldPath: String? = null): String? {
        val bitmap = MediaStore.Images.Media.getBitmap(context.contentResolver, uri)
        val newFile = buildFile(name)
        val fos = FileOutputStream(newFile)
        return try {
            oldPath?.let { tryDelete(it) }
            bitmap.compress(Bitmap.CompressFormat.JPEG, DEFAULT_QUALITY, fos)
            newFile.absolutePath
        } catch (e: Exception) {
            e.printStackTrace()
            null
        } finally {
            fos.close()
        }
    }

    private fun buildFile(name: String): File {
        return File(context.getDir("imageDir", Context.MODE_PRIVATE), "${name}_${System.currentTimeMillis()}.jpg")
    }

    private fun tryDelete(path: String) {
        File(path).apply {
            if (exists()) {
                delete()
            }
        }
    }

    companion object {
        const val DEFAULT_QUALITY = 100
    }
}
