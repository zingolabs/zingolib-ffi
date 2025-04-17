package org.zingolabs.zingolib_android

import org.junit.Test
import org.junit.Assert.assertTrue
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.platform.app.InstrumentationRegistry
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class ExampleInstrumentedTest {
    @Test
    fun testInitFromSeed() {
        val ctx = InstrumentationRegistry.getInstrumentation().targetContext
        val instance = Zingolib()
         assertTrue(instance != null)

        val result = instance.initFromSeed()
        assertTrue(result)
    }
}
